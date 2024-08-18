# Task 09: Multilevel Dockerfile and Targeted Build with Multifile Docker Compose

![Static Badge](https://img.shields.io/badge/build-Ubuntu-brightgreen?style=flat&logo=ubuntu&label=Linux&labelColor=Orange&color=red) ![Static Badge](https://img.shields.io/badge/Docker-27.0.3-skyblue?style=flat&logo=docker&label=Docker) ![Static Badge](https://img.shields.io/badge/Linux-Task09-Orange?style=flat&label=DevOps&labelColor=blue&color=gray)

## Overview

In this task, you will create optimized Docker images using multistage Dockerfiles for different environments and manage these environments with multifile Docker Compose configurations. This approach allows you to streamline the building process and separate configurations for development and production environments.

## Part 1: Multistage Dockerfile

### Multistage Dockerfile Explained

This Dockerfile is designed to build and run the Spring Petclinic application in both development and production environments. It uses three stages:

1. **Builder Stage**: 
   - **Base Image**: `eclipse-temurin:latest`
   - **Purpose**: This stage compiles the application and packages it into a JAR file.
   - **Commands**:
     ```Dockerfile
     FROM eclipse-temurin:latest AS builder
     WORKDIR /app
     COPY . .
     RUN ./mvnw package
     ```

2. **Development Environment Stage**:
   - **Base Image**: `eclipse-temurin:latest`
   - **Purpose**: This stage creates a lightweight image containing only the compiled application for development use.
   - **Commands**:
     ```Dockerfile
     FROM eclipse-temurin:latest AS dev
     WORKDIR /app
     COPY --from=builder /app/target .
     EXPOSE 8080
     CMD ["/bin/sh", "-c", "java -jar *.jar"]
     ```

3. **Production Environment Stage**:
   - **Base Image**: `eclipse-temurin:latest`
   - **Purpose**: This stage creates a production-ready image optimized for deployment.
   - **Commands**:
     ```Dockerfile
     FROM eclipse-temurin:latest AS prod
     WORKDIR /app
     COPY --from=builder /app/target .
     EXPOSE 8080
     CMD ["/bin/sh", "-c", "java -jar *.jar"]
     ```

## Part 2: Multifile Docker Compose

### Docker Compose Configurations

You will create different Docker Compose files to handle the development and production environments separately.

1. **Base Docker Compose File** (`docker-compose.yml`):
   - **Purpose**: Defines shared services and settings for both environments.
   - **Content**:
     ```yaml
     version: '3.8'
     services:
       app:
         container_name: petclinic-app-target
         ports:
           - "5000:8080"
         depends_on:
           - db
     ```

2. **Development Docker Compose File** (`docker-compose-dev.yml`):
   - **Purpose**: Sets up the development environment using MySQL.
   - **Content**:
     ```yaml
     version: '3.8'
     services:
       db:
         image: mysql:latest
         container_name: petclinic-db-mysql-dev
         environment:
           MYSQL_ROOT_PASSWORD: rootpassword
           MYSQL_DATABASE: petclinic
           MYSQL_USER: petclinic
           MYSQL_PASSWORD: petclinicpassword
         ports:
           - "3306"
         volumes:
           - db_data:/var/lib/mysql

       app:
         build:
           context: .
           target: dev
         container_name: petclinic-app-dev
         environment:
           - MYSQL_URL=jdbc:mysql://db:3306/petclinic
           - MYSQL_USER=petclinic
           - MYSQL_PASS=petclinicpassword
           - SPRING_PROFILES_ACTIVE=mysql
         ports:
           - "8080:8080"
         depends_on:
           - db
     volumes:
       db_data:
     ```

3. **Production Docker Compose File** (`docker-compose-prod.yml`):
   - **Purpose**: Sets up the production environment using PostgreSQL.
   - **Content**:
     ```yaml
     version: '3.8'
     services:
       db:
         image: postgres:latest
         container_name: petclinic-db-postgres-prod
         environment:
           - POSTGRES_USER=petclinic
           - POSTGRES_PASSWORD=petclinic
           - POSTGRES_DB=petclinic
         ports:
           - "5432"
         volumes:
           - postgres-volume:/var/lib/postgresql/data

       app:
         build:
           context: .
           target: prod
         container_name: petclinic-app
         environment:
           - POSTGRES_USER=petclinic
           - POSTGRES_PASSWORD=petclinic
           - POSTGRES_URL=jdbc:postgresql://db:5432/petclinic
           - SPRING_PROFILES_ACTIVE=postgres
         ports:
           - "8080:8080"
         depends_on:
           - db
     volumes:
       postgres-volume:
     ```

### Running the Application

1. **Development Environment**:
   ```bash
   docker compose -f docker-compose.yml -f docker-compose-dev.yml up --build
   ```

2. **Production Environment**:
   ```bash
   docker compose -f docker-compose.yml -f docker-compose-prod.yml up --build
   ```

### Testing the Application

- **Add Data**: After starting the containers in either environment, access the application and add data.
- **Stop Containers**:
  - Development: `docker compose -f docker-compose.yml -f docker-compose-dev.yml down`
  - Production: `docker compose -f docker-compose.yml -f docker-compose-prod.yml down`
- **Restart Containers**:
  - Development: `docker compose -f docker-compose.yml -f docker-compose-dev.yml up`
  - Production: `docker compose -f docker-compose.yml -f docker-compose-prod.yml up`
- **Verify Data Persistence**: Ensure the data added earlier is retained after restarting the containers.