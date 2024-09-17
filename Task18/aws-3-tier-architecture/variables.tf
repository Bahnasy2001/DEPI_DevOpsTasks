variable "region" {
  description = "The Region for AWS"
  type        = string
  default     = "us-west-2"
}
# VPC Variables
variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# Subnet Variables
variable "public_subnet_cidr_1" {
  description = "CIDR block for the first public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_cidr_2" {
  description = "CIDR block for the second public subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_cidr_1" {
  description = "CIDR block for the first private subnet"
  type        = string
  default     = "10.0.3.0/24"
}

variable "private_subnet_cidr_2" {
  description = "CIDR block for the second private subnet"
  type        = string
  default     = "10.0.4.0/24"
}

# Instance Variables
variable "instance_type" {
  description = "The instance type to use for the EC2 instances"
  type        = string
  default     = "t2.micro"
}

# AMI Variables
variable "web_ami" {
  description = "The AMI ID for the web tier instances"
  type        = string
  default     = "ami-0c55b159cbfafe1f0"  # Example AMI ID; replace with a valid one
}

variable "app_ami" {
  description = "The AMI ID for the application tier instances"
  type        = string
  default     = "ami-0c55b159cbfafe1f0"  # Example AMI ID; replace with a valid one
}

# Auto Scaling Variables
variable "desired_capacity" {
  description = "Desired number of EC2 instances in each ASG"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum number of EC2 instances in each ASG"
  type        = number
  default     = 2
}

variable "min_size" {
  description = "Minimum number of EC2 instances in each ASG"
  type        = number
  default     = 1
}

# RDS Variables
variable "db_instance_class" {
  description = "The RDS instance class"
  type        = string
  default     = "db.t2.micro"
}

variable "db_name" {
  description = "The name of the database"
  type        = string
  default     = "mydb"
}

variable "db_username" {
  description = "The database username"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "The database password"
  type        = string
  default     = "password"  # Ensure you manage this securely
}

variable "db_allocated_storage" {
  description = "The allocated storage for the database in GB"
  type        = number
  default     = 20
}
