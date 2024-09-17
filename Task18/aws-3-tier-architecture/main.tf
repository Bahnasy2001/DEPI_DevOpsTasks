provider "aws" {
  region     = var.region
}
#####################################################################
############ Create the S3 Bucket and DynamoDB Table ################
#####################################################################
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"  # Replace with your actual bucket name
    key            = "terraform/terraform.tfstate"  # Path to store the state file
    region         = "us-west-2" # Your preferred region
    encrypt        = true
    dynamodb_table = "terraform-state-locks"  # DynamoDB table for locking
  }
}

# Create an S3 Bucket for storing the tfstate file
resource "aws_s3_bucket" "terraform_state" {
  bucket = "my-terraform-state-bucket"  # Change this to your desired bucket name
}

# Create a DynamoDB Table for state locking
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-state-locks"
}
#####################################################################
##################### Define VPC and Subnets ########################
#####################################################################
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
}

resource "aws_subnet" "public_1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidr_1
  availability_zone = "us-west-2a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "public_2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidr_2
  availability_zone = "us-west-2b"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private_1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidr_1
  availability_zone = "us-west-2a"
}

resource "aws_subnet" "private_2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidr_2
  availability_zone = "us-west-2b"
}
#####################################################################
########### Define Internet Gateway and NAT Gateway #################
#####################################################################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_eip" "nat_eip" {
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_1.id
}
#####################################################################
##################### Create Route Tables ###########################
#####################################################################
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_rt_assoc_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_rt_assoc_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
}

resource "aws_route_table_association" "private_rt_assoc_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_rt_assoc_2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private_rt.id
}

#####################################################################
########### Create Load Balancer for Web Tier ########################
#####################################################################
resource "aws_lb" "web_alb" {
  name               = "web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web_sg.id]
  subnets            = [aws_subnet.public_1.id, aws_subnet.public_2.id]
  enable_deletion_protection = false
  idle_timeout       = 300  # Idle timeout in seconds
}

resource "aws_lb_target_group" "web_target_group" {
  name     = "web-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold    = 3
    unhealthy_threshold  = 3
  }
}

resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "OK"
      status_code  = "200"
    }
  }
}

######Web and Application Tier####
#####################################################################
########### Create Auto Scaling Groups for EC2 Instances ############
#####################################################################
# resource "aws_launch_configuration" "web_launch_config" {
#   image_id        = "ami-0c55b159cbfafe1f0"  # Replace with your custom AMI
#   instance_type   = "t2.micro"
# }

resource "aws_launch_template" "web_launch_temp" {
  name_prefix     = "web_launch_temp"
  image_id        = var.web_ami  # Replace with your custom AMI
  instance_type   = var.instance_type
}

resource "aws_autoscaling_group" "web_asg" {
  desired_capacity     = var.desired_capacity
  max_size             = var.max_size
  min_size             = var.min_size
#   launch_configuration = aws_launch_configuration.web_launch_config.id
  vpc_zone_identifier  = [aws_subnet.public_1.id, aws_subnet.public_2.id]

  launch_template {
    id      = aws_launch_template.web_launch_temp.id
  }
  
  tag {
    key                 = "Name"
    value               = "Web Tier"
    propagate_at_launch = true
  }

  load_balancers = [aws_lb.web_alb.id]

  health_check_type          = "EC2"
  health_check_grace_period = 300
}
# Web Security Group
resource "aws_security_group" "web_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow traffic from anywhere (for testing)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#####################################################################
############### Application Tier Launch Configuration ###############
#####################################################################
resource "aws_launch_configuration" "app_launch_config" {
  image_id        = var.app_ami # Replace with your own AMI ID
  instance_type   = var.instance_type

  # You can use this to set up your application server (e.g., with a startup script)
  # user_data = file("app-startup.sh") 
}

# Application Tier Auto Scaling Group
resource "aws_autoscaling_group" "app_asg" {
  desired_capacity     = var.desired_capacity
  max_size             = var.max_size
  min_size             = var.min_size
  launch_configuration = aws_launch_configuration.app_launch_config.id
  vpc_zone_identifier  = [aws_subnet.private_1.id, aws_subnet.private_2.id]

  tag {
    key                 = "Name"
    value               = "Application Tier"
    propagate_at_launch = true
  }
}
# Application Security Group
resource "aws_security_group" "app_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.web_sg.id]  # Allow traffic from Web Tier SG
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#####################################################################
###################### Database Tier (RDS) ########################## 
#####################################################################
# RDS Security Group
resource "aws_security_group" "db_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# DB Subnet Group
resource "aws_db_subnet_group" "main" {
  name       = "main-db-subnet-group"
  subnet_ids = [aws_subnet.private_1.id, aws_subnet.private_2.id]

  tags = {
    Name = "Main DB Subnet Group"
  }
}

resource "aws_db_instance" "db" {
  allocated_storage    = var.db_allocated_storage
  engine               = "mysql"
  instance_class       = var.db_instance_class
  db_name              = var.db_name
  username             = var.db_username
  password             = var.db_password
  publicly_accessible  = false
  multi_az             = true
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  db_subnet_group_name = aws_db_subnet_group.main.name
}
#####################################################################
######################## Adding Provisioners ########################
#####################################################################
# Print Web Tier IPs
# Filter EC2 instances by tags for Web Tier
data "aws_instances" "web_instances" {
  filter {
    name   = "tag:aws:autoscaling:groupName"
    values = [aws_autoscaling_group.web_asg.name]
  }
}

# Filter EC2 instances by tags for App Tier
data "aws_instances" "app_instances" {
  filter {
    name   = "tag:aws:autoscaling:groupName"
    values = [aws_autoscaling_group.app_asg.name]
  }
}



# Provisioner to print Web Tier Private IPs
resource "null_resource" "print_web_ips" {
  provisioner "local-exec" {
    command = "echo Web Tier Private IPs: ${join(", ", data.aws_instances.web_instances.private_ips)}"
  }
  depends_on = [aws_autoscaling_group.web_asg]
}

# Provisioner to print App Tier Private IPs
resource "null_resource" "print_app_ips" {
  provisioner "local-exec" {
    command = "echo App Tier Private IPs: ${join(", ", data.aws_instances.app_instances.private_ips)}"
  }
  depends_on = [aws_autoscaling_group.app_asg]
}
