
# **Task 05: Docker Image Backing Up**

![Static Badge](https://img.shields.io/badge/build-Ubuntu-brightgreen?style=flat&logo=ubuntu&label=Linux&labelColor=Orange&color=red) ![Static Badge](https://img.shields.io/badge/Docker-27.0.3-skyblue?style=flat&logo=docker&label=Docker) ![Static Badge](https://img.shields.io/badge/Linux-Task05-Orange?style=flat&label=DevOps&labelColor=blue&color=gray)

## **Overview**
In this task, you'll learn how to back up a Docker image by committing a container, pushing it to Docker Hub, and saving it to a tar file. This process is essential for preserving and transferring Docker images.

## **Prerequisites**
- **Docker** installed on your system. (Refer to [Task 03](../Task03/README.md) for installation details using the `Docker.sh` script.)
- A **Docker Hub** account for pushing images to a remote repository.

## **Steps**

### 1. Commit the Docker Container
First, commit the running container `spring_petclinic_eclipse` to create a new Docker image.

```bash
sudo docker commit spring_petclinic_eclipse hassanbahnasy/spring:v2
```

### 2. Tag the Docker Image
Tag the Docker image to give it a version number or other identifier.

```bash
sudo docker tag Id12470fa662 hassanbahnasy/spring:v2
```

### 3. Log In to Docker Hub
Log in to your Docker Hub account to push the image.

```bash
sudo docker login
```

### 4. Push the Docker Image to Docker Hub
Push the newly created image to your Docker Hub repository.

```bash
sudo docker push hassanbahnasy/spring:v2
```

### 5. Save the Docker Image to a Tar File
Save the Docker image to a `.tar` file for backup or transfer purposes.

```bash
sudo docker save hassanbahnasy/spring -o hassanbahnasy/spring.tar
```

### 6. Load the Docker Image from the Tar File
Load the Docker image from the `.tar` file.

```bash
sudo docker load -i hassanbahnasy/spring.tar
```

### 7. Pull an Image from Another Repository
Pull an image from a different repository for backup or use.

```bash
docker pull mostafaamansour/appdynamics:v1
```

## **Conclusion**
In this task, we demonstrated how to back up a Docker image by committing a container, tagging, pushing it to Docker Hub, saving it as a tar file, and pulling an image from a different repository. These steps ensure that your Docker images are securely stored and easily accessible for future use.
