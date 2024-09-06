# Task 16: Kubernetes Setup for Spring Petclinic Application with MySQL Database

![Static Badge](https://img.shields.io/badge/build-Ubuntu-brightgreen?style=flat&logo=ubuntu&label=Linux&labelColor=Orange&color=red) ![Static Badge](https://img.shields.io/badge/Docker-27.0.3-skyblue?style=flat&logo=docker&label=Docker) ![Static Badge](https://img.shields.io/badge/Linux-Task16-Orange?style=flat&label=DevOps&labelColor=blue&color=gray) ![Static Badge](https://img.shields.io/badge/Kubernetes-1.30-cyan?style=plastic&logo=kubernetes)

This task involves setting up the Spring Petclinic application with a MySQL database on a Kubernetes cluster. The setup includes using ConfigMaps, Secrets, Persistent Volumes (PVs), Persistent Volume Claims (PVCs), Deployments, and Services to create and manage the application and database. The steps below outline the configuration and deployment details required to get this system running in Kubernetes.

## Table of Contents
- [Overview](#overview)
- [Architecture](#architecture)
- [Configuration Files](#configuration-files)
- [Setup Instructions](#setup-instructions)
- [Testing the Setup](#testing-the-setup)
- [Conclusion](#conclusion)

---

## Overview

The objective of this task is to deploy the Spring Petclinic application, backed by a MySQL database, in a Kubernetes cluster. The task demonstrates the use of Kubernetes resources like ConfigMaps, Secrets, Deployments, Services, and Persistent Volumes to manage application data, secrets, and scalability.

## Architecture

1. **MySQL Database**: Managed as a Kubernetes Deployment, the MySQL database is configured using a ConfigMap for environment variables and a Secret for storing sensitive information like passwords. A Persistent Volume is used to ensure data persistence.
   
2. **Spring Petclinic Application**: Deployed as a scalable Kubernetes Deployment with 3 replicas, the application connects to the MySQL database using environment variables. An initContainer is used to ensure that MySQL is up and running before the application starts.

## Configuration Files

### 1. `mysql-configmap.yml`
Contains non-sensitive configuration data for the MySQL database, such as the database URL and user credentials.

### 2. `mysql-secret.yml`
Stores sensitive information such as MySQL root and user passwords in an encrypted format.

### 3. `mysql-service.yml`
Exposes the MySQL database as a NodePort service.

### 4. `spring-petclinic-service.yml`
Exposes the Spring Petclinic application as a LoadBalancer service, allowing external access.

### 5. `mysql-pv.yml` and `mysql-pvc.yml`
Defines the Persistent Volume and Persistent Volume Claim for MySQL to store data persistently.

### 6. `mysql-deployment.yml`
Creates the MySQL database deployment with environment variables mapped from ConfigMaps and Secrets.

### 7. `spring-petclinic-deployment.yml`
Deploys the Spring Petclinic application with 3 replicas, ensuring high availability and automatic scaling.

## Setup Instructions

1. **Apply the ConfigMap and Secret:**
   ```bash
   kubectl apply -f configmaps/mysql-configmap.yml
   kubectl apply -f secrets/mysql-secret.yml
   ```

2. **Create the Persistent Volume and Claim:**
   ```bash
   kubectl apply -f volumes/mysql-pv.yml
   kubectl apply -f volumes/mysql-pvc.yml
   ```

3. **Deploy MySQL:**
   ```bash
   kubectl apply -f deplyments/mysql-deployment.yml
   kubectl apply -f services/mysql-service.yml
   ```

4. **Deploy Spring Petclinic Application:**
   ```bash
   kubectl apply -f deplyments/spring-petclinic-deployment.yml
   kubectl apply -f services/spring-petclinic-service.yml
   ```

## Testing the Setup

1. Check the status of all Pods and Services:
   ```bash
   kubectl get pods -n spring-petclinic-dev
   kubectl get services -n spring-petclinic-dev
   ```

2. Access the Spring Petclinic application via the LoadBalancer service:
   ```bash
   kubectl describe service spring-petclinic-service -n spring-petclinic-dev
   ```
   Use the external IP of the LoadBalancer to access the application in your browser.

## Conclusion

This task provides hands-on experience in setting up a multi-tier application using Kubernetes. It demonstrates how ConfigMaps, Secrets, Deployments, and Services can be used to manage both application logic and persistent data in a Kubernetes cluster. This setup ensures scalability, high availability, and secure management of sensitive data.

