# Task 18: Deploying a Highly Available 3-Tier Architecture on AWS with Terraform

---
![Static Badge](https://img.shields.io/badge/build-Ubuntu-brightgreen?style=flat&logo=ubuntu&label=Linux&labelColor=Orange&color=red) ![Static Badge](https://img.shields.io/badge/Linux-Task18-Orange?style=flat&label=DevOps&labelColor=blue&color=gray) ![Static Badge](https://img.shields.io/badge/terraform-v1.9.5-orange?style=plastic&logo=terraform&logoColor=violet&labelColor=white) ![Static Badge](https://img.shields.io/badge/aws-v2.17.52-darkblue?style=plastic&logo=amazonwebservices&logoColor=orange&label=aws&labelColor=brightblue&color=darkblue)


## Overview

This README will guide you through deploying a **Highly Available 3-Tier Architecture** on AWS using **Terraform**. The architecture consists of three main components: a **Web Tier**, an **Application Tier**, and a **Database Tier**. Each tier is deployed across multiple **Availability Zones** for high availability. 

In this setup, Auto Scaling Groups (ASGs) are used for the **Web** and **Application** tiers, and an **RDS MySQL** instance is used for the **Database** tier. Security groups are configured to restrict inbound traffic.

---

## Architecture Overview

1. **Web Tier (Presentation Layer)**:
   - 2 public subnets (across two Availability Zones) for EC2 instances.
   - EC2 instances in an Auto Scaling Group, acting as web servers.
   - Security group that allows inbound traffic on HTTP (port 80) from the internet.

2. **Application Tier (Logic Layer)**:
   - 2 private subnets (across two Availability Zones) for EC2 instances.
   - EC2 instances in an Auto Scaling Group, acting as application servers.
   - Security group that allows inbound traffic from the **Web Tier**.

3. **Database Tier (Data Layer)**:
   - 2 private subnets (across two Availability Zones) for the RDS MySQL instance.
   - Security group that allows inbound traffic from the **Application Tier**.
   - MySQL RDS instance deployed in the private subnets.

![aws_3-tier-architecture](../aws.jpeg)
---

## Prerequisites

1. **AWS Account** with appropriate permissions.
2. **Terraform** installed (v0.12+).
3. **AWS CLI** installed and configured with the necessary credentials.
4. An SSH key pair to access EC2 instances (optional but recommended).

---

## Steps to Deploy

### Step 1: Clone the Repository

Clone this repository to your local machine:

```bash
git clone https://github.com/Bahnasy2001/DEPI_DevOpsTasks
cd Task18
```

### Step 2: Update the Variables

Update the variables in the `variables.tf` and `terraform.tfvars` file to suit your environment. Key variables include:

- `region`: AWS region where the resources will be created.
- `vpc_cidr`: CIDR block for the VPC.
- `public_subnets_cidrs`: CIDR blocks for public subnets.
- `private_subnets_cidrs`: CIDR blocks for private subnets.
- `db_password`: The password for the RDS instance.

### Step 3: Initialize Terraform

Initialize Terraform to download the required providers:

```bash
terraform init
```

### Step 4: Plan the Deployment

Run the following command to create an execution plan:

```bash
terraform plan
```

Check the output to verify that the infrastructure will be created as expected.

### Step 5: Apply the Configuration

Once you’re ready to proceed, apply the Terraform configuration:

```bash
terraform apply
```

Type `yes` to confirm the changes.

### Step 6: Verify the Output

After applying, Terraform will output the **private IPs** of the instances in the Web and Application tiers

---

## Key Components

Uses an S3 bucket for storing Terraform state with DynamoDB for state locking.

### VPC and Subnets

- **VPC**: A Virtual Private Cloud that spans your AWS region.
- **Subnets**: 
  - **Public Subnets**: Host EC2 instances for the web tier.
  - **Private Subnets**: Host EC2 instances for the application tier and RDS instances.

### Auto Scaling Groups

- **Web Tier**:
  - Auto Scaling Group deploys web servers in public subnets.
  - Instances are fronted by a security group that allows HTTP traffic.

- **Application Tier**:
  - Auto Scaling Group deploys app servers in private subnets.
  - Security group only allows traffic from the Web Tier.

### RDS MySQL Database

- **Database Tier**:
  - MySQL RDS instance in private subnets.
  - Security group allows MySQL traffic (port 3306) only from the Application Tier.

---

## Provisioners

Terraform uses local-exec provisioners to print the private IP addresses of the instances created in the Web and Application tiers.

### Web Tier IP Provisioner

```hcl
resource "null_resource" "print_web_ips" {
  provisioner "local-exec" {
    command = "echo Web Tier Private IPs: ${join(", ", data.aws_instances.web_instances.private_ips)}"
  }
}
```

### Application Tier IP Provisioner

```hcl
resource "null_resource" "print_app_ips" {
  provisioner "local-exec" {
    command = "echo App Tier Private IPs: ${join(", ", data.aws_instances.app_instances.private_ips)}"
  }
}
```

---

## Destroying the Environment

To destroy all the resources created by Terraform, run the following command:

```bash
terraform destroy
```

Type `yes` to confirm the deletion.

---

## Additional Notes

- **High Availability**: The architecture spans two Availability Zones to ensure redundancy and high availability.
- **Security**: Security groups are tightly controlled, ensuring only necessary traffic is allowed between tiers.
- **Cost Considerations**: As with any cloud architecture, ensure to monitor your resources and decommission any unneeded infrastructure to avoid unnecessary costs.

---

## Conclusion

This Terraform configuration allows you to deploy a highly available 3-tier architecture in AWS. The architecture is flexible and can be adapted to suit various use cases. You can customize the number of instances, subnets, and security settings based on your requirements.

Feel free to experiment and scale the architecture according to your needs!
