# DEPI_DevOpsTasks

![Static Badge](https://img.shields.io/badge/build-Ubuntu-brightgreen?style=flat&logo=ubuntu&label=Linux&labelColor=Orange&color=red) ![Static Badge](https://img.shields.io/badge/Docker-27.0.3-skyblue?style=flat&logo=docker&label=Docker) ![Static Badge](https://img.shields.io/badge/jenkins-java%2017.0.12-brightred?style=flat&logo=jenkins&logoColor=darkred&label=jenkins&labelColor=grey&color=orange) ![Static Badge](https://img.shields.io/badge/ngrok-3.8.0-white?style=plastic&logo=ngrok&label=ngrok&labelColor=black&color=white) ![Static Badge](https://img.shields.io/badge/nginx-1.18.0-grey?style=flat&logo=nginx&label=nginx&labelColor=darkgreen&color=grey) ![Static Badge](https://img.shields.io/badge/Kubernetes-1.30-cyan?style=plastic&logo=kubernetes) ![Static Badge](https://img.shields.io/badge/terraform-v1.9.5-orange?style=plastic&logo=terraform&logoColor=violet&labelColor=white) ![Static Badge](https://img.shields.io/badge/aws-v2.17.52-darkblue?style=plastic&logo=amazonwebservices&logoColor=orange&label=aws&labelColor=brightblue&color=darkblue) ![Static Badge](https://img.shields.io/badge/azure%20-%20v2.64.0-blue?logoColor=grey) ![Static Badge](https://img.shields.io/badge/ansible-v2.13.13-grey?logo=ansible&logoColor=black&label=ansible&labelColor=white)


This repository features a collection of tasks covering topics like Linux, Nginx, Docker, Jenkins , Terraform And Ansible. Each task is organized into its own folder with a corresponding README file that provides comprehensive instructions.

## Table of Contents

### Linux

1. [Task 01: Basic File Operations](Task01/README.md)
2. [Task 02: User and Group Management, Script Permissions, and Archiving](Task02/README.md)

### Docker and Nginx

3. [Task 03: Docker Installation, NGINX Setup, and Port Configuration](Task03/README.md)
4. [Task 04: Docker and NGINX Setup with PHP-FPM and Caching](Task04/README.md)
5. [Task 05: Docker Image Backing Up](Task05/README.md)
6. [Task 06: Dockerfile Building Basics](Task06/README.md)
7. [Task 07: Docker Volumes using Nginx](Task07/README.md)
8. [Task 08: Docker Networking Manual and Using Docker Compose](Task08/README.md)
9. [Task 09: Multilevel Dockerfile and Targeted Build with Multifile Docker Compose](Task09/README.md)
10. [Task 10: Two Complete Applications Using Load Balancer and Docker Compose](Task10/README.md)
11. [Task 11: ELK Stack and Nextcloud-Postgres with Docker Compose](Task11/README.md)

### Jenkins

12. [Task 12: Jenkins Freestyle Basics](Task12/README.md)
13. [Task 13: Running a Docker-in-Docker (DinD) Jenkins Setup](Task13/README.md)
14. [Task 14: Advanced Jenkins Pipeline Configuration](Task14/README.md)

### Kubernetes

15. [Task 15: Kubernetes Labs](Task15/README.md)
16. [Task 16: Kubernetes Setup for Spring Petclinic Application with MySQL Database](Task16/README.md)
17. [Task 17: MongoDB and Mongo Express Deployment on Kubernetes](Task17/README.md)

### Terraform
18. [Task 18: Deploying a Highly Available 3-Tier Architecture on AWS with Terraform](Task18/README.md)
19. [Task 19: Azure 3-Tier Architecture with Terraform](Task19/README.md)

### Ansible
20. [Task 20: Install Sonatype Nexus 3 with Ansible](Task20/README.md)
---

### Task 01: Basic File Operations
The goal of this task is to familiarize yourself with basic file operations in a Unix/Linux environment.

### Task 02: User and Group Management, Script Permissions, and Archiving
This task focuses on managing users, groups, file permissions, and archiving in a Unix/Linux environment.

### Task 03: Docker Installation, NGINX Setup, and Port Configuration
This task involves installing Docker on a Linux system, setting up a simple website using NGINX, and configuring NGINX to run on a non-default port (82).

### Task 04: Docker and NGINX Setup with PHP-FPM and Caching
This task involves setting up a Docker container for the Spring Petclinic Node.js application, configuring an NGINX server with PHP 7.3 and PHP-FPM, and setting up caching and gzip compression for static content.

### Task 05: Docker Image Backing Up
In this task, you'll learn how to back up a Docker image by committing a container, pushing it to Docker Hub, and saving it to a tar file. This process is essential for preserving and transferring Docker images.

### Task 06: Dockerfile Building Basics
In this task, we will create a Dockerfile to containerize the Spring Petclinic application, build the Docker image, and run the Docker container.

### Task 07: Docker Volumes using Nginx
In this task, we set up an Nginx server to serve a CV application, use Docker bind mounts and volumes, and demonstrate how to manage and persist data across Docker containers.

### Task 08: Docker Networking Manual and Using Docker Compose
In this task, we connect the Spring Petclinic application with a MySQL database using Docker. This task is divided into two parts: manual Docker networking and using Docker Compose. This demonstrates how to manage multi-container applications and network them together effectively.

### Task 09: Multilevel Dockerfile and Targeted Build with Multifile Docker Compose
In this task, you will create optimized Docker images using multistage Dockerfiles for different environments and manage these environments with multifile Docker Compose configurations. This approach allows you to streamline the building process and separate configurations for development and production environments.

### Task 10: Two Complete Applications Using Load Balancer and Docker Compose
This task demonstrates how to Dockerize two complete applications—**Spring Petclinic** and **mongo-express**—and manage them using Docker Compose. Additionally, we use **Nginx** as a load balancer to distribute traffic across multiple replicas of these applications.

### Task 11: ELK Stack and Nextcloud-Postgres with Docker Compose
This task involves setting up two distinct Docker Compose environments:

1. **ELK Stack (Elasticsearch, Logstash, Kibana)**: A robust solution for managing and visualizing log data.
2. **Nextcloud-Postgres Stack**: A cloud storage solution using Nextcloud with a PostgreSQL database backend.

Each setup demonstrates how to orchestrate multi-container applications using Docker Compose.

### Task 12: Jenkins Freestyle Basics
This task demonstrates the basics of Jenkins by creating a simple freestyle job that interacts with Docker. The job involves removing an existing Docker image of Nginx and then recreating it with port mapping. This task is designed to showcase Jenkins' capability to automate Docker-related tasks.

### Task 13: Running a Docker-in-Docker (DinD) Jenkins Setup
In this task, we set up a Jenkins environment using Docker-in-Docker (DinD) to run Jenkins inside a Docker container. This setup allows Jenkins to interact with Docker directly, making it suitable for continuous integration and continuous deployment (CI/CD) pipelines. We also create a Jenkins agent using another Docker container, configure Docker Hub credentials, and implement a Jenkins pipeline with scheduling.

### Task 14: Advanced Jenkins Pipeline Configuration
This task involves creating and configuring Jenkins pipelines with advanced features such as agent usage, parameterization, Slack notifications, webhook integration using ngrok, and setting up a Jenkins agent on Windows.

### Task 15: Kubernetes Labs

Task 15 is a comprehensive set of Kubernetes labs designed to provide hands-on experience with various aspects of Kubernetes, from basic cluster setup to advanced deployment strategies. These labs are structured to gradually increase in complexity, covering topics such as Pods, ReplicaSets, Deployments, Namespaces, ConfigMaps, Secrets, RBAC, and Ingress Controllers. By completing these labs, you will gain a solid understanding of how to manage and scale applications in a Kubernetes environment.

### Task 16: Kubernetes Setup for Spring Petclinic Application with MySQL Database

In this task, you will deploy the Spring Petclinic application with a MySQL database in a Kubernetes cluster. The setup demonstrates the use of Kubernetes resources like ConfigMaps, Secrets, Persistent Volumes, Deployments, and Services to manage application data, secrets, and scalability.


### Task 17: MongoDB and Mongo Express Deployment on Kubernetes

In this task, MongoDB and Mongo Express are deployed on a Kubernetes cluster using Kubernetes ConfigMaps, Secrets, Persistent Volumes, Persistent Volume Claims, Deployments, and Services. MongoDB is managed through a ClusterIP service, while Mongo Express is exposed via a LoadBalancer service for easy access. This setup allows database management using the Mongo Express web interface.

Each lab is organized in its own directory with a detailed README file that includes instructions and key concepts. The labs are ideal for anyone looking to deepen their knowledge of Kubernetes and its ecosystem.

### Task 18: Deploying a Highly Available 3-Tier Architecture on AWS with Terraform

In this task, This Terraform project deploys a scalable 3-tier architecture on AWS with public subnets for web servers, private subnets for application servers, and private subnets for an RDS MySQL database. It uses an S3 bucket for state storage and DynamoDB for state locking, ensuring high availability and redundancy.

### Task 19: Azure 3-Tier Architecture with Terraform

This project provisions a highly available 3-tier architecture in Azure using Terraform. It includes separate web, application, and database tiers, each isolated across multiple subnets for security and performance. The deployment uses modules for scalability and follows best practices for resource management, automation, and availability. Key features include VMs, load balancers, and network security.

### Task 20: Install Sonatype Nexus 3 with Ansible

This Ansible role automates the installation of Sonatype Nexus 3 on a Linux server. It updates system packages, installs necessary dependencies (like Java and wget), downloads and extracts Nexus, creates a service for Nexus, and ensures it starts on boot. After the installation, the role verifies that Nexus is running properly and accessible via port 8081.

---
