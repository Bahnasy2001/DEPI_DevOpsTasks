# DEPI_DevOpsTasks

![Static Badge](https://img.shields.io/badge/build-Ubuntu-brightgreen?style=flat&logo=ubuntu&label=Linux&labelColor=Orange&color=red) ![Static Badge](https://img.shields.io/badge/Docker-27.0.3-skyblue?style=flat&logo=docker&label=Docker) ![Static Badge](https://img.shields.io/badge/jenkins-java%2017.0.12-brightred?style=flat&logo=jenkins&logoColor=darkred&label=jenkins&labelColor=grey&color=orange) ![Static Badge](https://img.shields.io/badge/ngrok-3.8.0-white?style=plastic&logo=ngrok&label=ngrok&labelColor=black&color=white) ![Static Badge](https://img.shields.io/badge/nginx-1.18.0-grey?style=flat&logo=nginx&label=nginx&labelColor=darkgreen&color=grey) 

This repository features a collection of tasks covering topics like Linux, Nginx, Docker, and Jenkins. Each task is organized into its own folder with a corresponding README file that provides comprehensive instructions.

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

---

#### Task 01: Basic File Operations
The goal of this task is to familiarize yourself with basic file operations in a Unix/Linux environment.

#### Task 02: User and Group Management, Script Permissions, and Archiving
This task focuses on managing users, groups, file permissions, and archiving in a Unix/Linux environment.

#### Task 03: Docker Installation, NGINX Setup, and Port Configuration
This task involves installing Docker on a Linux system, setting up a simple website using NGINX, and configuring NGINX to run on a non-default port (82).

#### Task 04: Docker and NGINX Setup with PHP-FPM and Caching
This task involves setting up a Docker container for the Spring Petclinic Node.js application, configuring an NGINX server with PHP 7.3 and PHP-FPM, and setting up caching and gzip compression for static content.

#### Task 05: Docker Image Backing Up
In this task, you'll learn how to back up a Docker image by committing a container, pushing it to Docker Hub, and saving it to a tar file. This process is essential for preserving and transferring Docker images.

#### Task 06: Dockerfile Building Basics
In this task, we will create a Dockerfile to containerize the Spring Petclinic application, build the Docker image, and run the Docker container.

#### Task 07: Docker Volumes using Nginx
In this task, we set up an Nginx server to serve a CV application, use Docker bind mounts and volumes, and demonstrate how to manage and persist data across Docker containers.

#### Task 08: Docker Networking Manual and Using Docker Compose
In this task, we connect the Spring Petclinic application with a MySQL database using Docker. This task is divided into two parts: manual Docker networking and using Docker Compose. This demonstrates how to manage multi-container applications and network them together effectively.

#### Task 09: Multilevel Dockerfile and Targeted Build with Multifile Docker Compose
In this task, you will create optimized Docker images using multistage Dockerfiles for different environments and manage these environments with multifile Docker Compose configurations. This approach allows you to streamline the building process and separate configurations for development and production environments.

#### Task 10: Two Complete Applications Using Load Balancer and Docker Compose
This task demonstrates how to Dockerize two complete applications—**Spring Petclinic** and **mongo-express**—and manage them using Docker Compose. Additionally, we use **Nginx** as a load balancer to distribute traffic across multiple replicas of these applications.

#### Task 11: ELK Stack and Nextcloud-Postgres with Docker Compose
This task involves setting up two distinct Docker Compose environments:

1. **ELK Stack (Elasticsearch, Logstash, Kibana)**: A robust solution for managing and visualizing log data.
2. **Nextcloud-Postgres Stack**: A cloud storage solution using Nextcloud with a PostgreSQL database backend.

Each setup demonstrates how to orchestrate multi-container applications using Docker Compose.

#### Task 12: Jenkins Freestyle Basics
This task demonstrates the basics of Jenkins by creating a simple freestyle job that interacts with Docker. The job involves removing an existing Docker image of Nginx and then recreating it with port mapping. This task is designed to showcase Jenkins' capability to automate Docker-related tasks.

#### Task 13: Running a Docker-in-Docker (DinD) Jenkins Setup
In this task, we set up a Jenkins environment using Docker-in-Docker (DinD) to run Jenkins inside a Docker container. This setup allows Jenkins to interact with Docker directly, making it suitable for continuous integration and continuous deployment (CI/CD) pipelines. We also create a Jenkins agent using another Docker container, configure Docker Hub credentials, and implement a Jenkins pipeline with scheduling.

#### Task 14: Advanced Jenkins Pipeline Configuration
This task involves creating and configuring Jenkins pipelines with advanced features such as agent usage, parameterization, Slack notifications, webhook integration using ngrok, and setting up a Jenkins agent on Windows.