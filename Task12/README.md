# Task 12: Jenkins Freestyle Basics

![Static Badge](https://img.shields.io/badge/build-Ubuntu-brightgreen?style=flat&logo=ubuntu&label=Linux&labelColor=Orange&color=red) ![Static Badge](https://img.shields.io/badge/Docker-27.0.3-skyblue?style=flat&logo=docker&label=Docker) ![Static Badge](https://img.shields.io/badge/nginx-1.18.0-grey?style=flat&logo=nginx&label=nginx&labelColor=darkgreen&color=grey) ![Static Badge](https://img.shields.io/badge/jenkins-java%2017.0.12-brightred?style=flat&logo=jenkins&logoColor=darkred&label=jenkins&labelColor=grey&color=orange) ![Static Badge](https://img.shields.io/badge/Linux-Task12-Orange?style=flat&label=DevOps&labelColor=blue&color=gray)

## Overview

This task demonstrates the basics of Jenkins by creating a simple freestyle job that interacts with Docker. The job involves removing an existing Docker image of Nginx and then recreating it with port mapping. This task is designed to showcase Jenkins' capability to automate Docker-related tasks.

## Steps

### 1. Add Jenkins to the Docker Group
To allow Jenkins to interact with Docker, add the Jenkins user to the Docker group.

```bash
sudo usermod -aG docker jenkins
```

### 2. Remove Existing Nginx Docker Image

Create a Jenkins freestyle job that removes the existing Nginx Docker image named `nginx_jenkins-Task12`.

- Open Jenkins and create a new freestyle project.
- In the build section, add an **Execute shell** build step.
- In the shell script, enter the following command:

    ```bash
    docker rm -f nginx_jenkins-Task12
    ```

### 3. Recreate Nginx Docker Image

Next, recreate the Nginx Docker image and map port 80 to 6000.

- Add another **Execute shell** build step to the same Jenkins job.
- In the shell script, enter the following command:

    ```bash
    docker run --name nginx_jenkins-Task12 -d -p 6060:80 nginx
    ```

- Save and run the job to recreate the Nginx Docker image.

### 4. Verify the Nginx Container

After the job completes, verify that the Nginx container is running:

```bash
docker ps
```

- Look for a container named `nginx_jenkins-Task12` with port 6060 mapped to port 80.

## Conclusion

This task demonstrates how Jenkins can automate Docker tasks, specifically managing Docker images and containers. By completing this task, you have gained a basic understanding of creating Jenkins freestyle jobs that interact with Docker.
