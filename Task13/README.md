# Task 13: Running a Docker-in-Docker (DinD) Jenkins Setup

![Static Badge](https://img.shields.io/badge/build-Ubuntu-brightgreen?style=flat&logo=ubuntu&label=Linux&labelColor=Orange&color=red) ![Static Badge](https://img.shields.io/badge/Docker-27.0.3-skyblue?style=flat&logo=docker&label=Docker) ![Static Badge](https://img.shields.io/badge/jenkins-java%2017.0.12-brightred?style=flat&logo=jenkins&logoColor=darkred&label=jenkins&labelColor=grey&color=orange) ![Static Badge](https://img.shields.io/badge/Linux-Task13-Orange?style=flat&label=DevOps&labelColor=blue&color=gray)

## Overview
In this task, we set up a Jenkins environment using Docker-in-Docker (DinD) to run Jenkins inside a Docker container. This setup allows Jenkins to interact with Docker directly, making it suitable for continuous integration and continuous deployment (CI/CD) pipelines. We also create a Jenkins agent using another Docker container, configure Docker Hub credentials, and implement a Jenkins pipeline with scheduling.

## Steps

### 1. Run DinD Container for Jenkins

#### Dockerfile for Jenkins

```Dockerfile
FROM jenkins/jenkins:latest

USER root

# Install Docker CLI
RUN apt-get update -qq && \
    apt-get install -qq \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/debian \
    $(lsb_release -cs) \
    stable" && \
    apt-get update -qq && \
    apt-get install -qq docker-ce-cli

# Ensure Jenkins user and group have the correct UID and GID
RUN groupmod -g 135 jenkins && \
    usermod -u 129 -g 135 jenkins

# Adjust permissions for Jenkins home directory
RUN chown -R 129:135 /var/jenkins_home && \
    chmod -R 755 /var/jenkins_home

# Optional: Add Docker group and add the Jenkins user to it
RUN groupadd docker && \
    usermod -aG docker jenkins

# Ensure Jenkins user has UID 129
RUN usermod -u 129 jenkins

# Switch back to Jenkins user
USER jenkins

# Default command to run Jenkins
CMD ["jenkins.sh"]
```

**Explanation:**
- **Docker CLI Installation:** The Docker CLI is installed to allow Jenkins to interact with Docker from within the container.
- **User and Group Configuration:** The Jenkins user and group are configured to ensure proper permissions.
- **Docker Group:** Jenkins is added to the Docker group, allowing it to execute Docker commands.
- **Jenkins Execution:** The default command starts the Jenkins server.

#### Running the Jenkins Container
To build and run the Jenkins container:
```bash
docker build . -t my-jenkins
docker run -d -p 8081:8080 -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/jenkins:/var/jenkins_home --name jenkins_Master my-jenkins
```
- **Mounting docker.sock:** This allows the Jenkins container to access the Docker daemon on the host machine.

### 2. Create Agent with Dockerfile

#### Dockerfile for Agent

```Dockerfile
FROM ubuntu:latest
USER root

# Install dependencies
RUN apt-get update -qq && \
    apt-get install -y \
        openjdk-17-jdk \
        openssh-server \
        ca-certificates \
        curl \
        gnupg \
        lsb-release

# Install Docker CLI
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list && \
    apt-get update -qq && \
    apt-get install -y docker-ce-cli

# Install Docker Engine
RUN apt-get install -y docker-ce

# Ensure Docker group exists with ID 998 and add Jenkins user to Docker group
RUN if ! getent group docker >/dev/null; then \
        groupadd -g 998 docker; \
    fi && \
    useradd -ms /bin/bash jenkins && \
    usermod -aG docker jenkins

# Set permissions and working directory
RUN mkdir -p /jenkins_home && \
    chmod 777 /jenkins_home
USER jenkins
WORKDIR /jenkins_home

# Default command
CMD ["/bin/bash"]
```

**Explanation:**
- **Installing Dependencies:** The Docker CLI, Docker Engine, and OpenJDK are installed to allow the agent to run and build Java applications.
- **SSH Setup:** The OpenSSH server is installed to enable SSH connectivity between Jenkins and the agent.
- **Docker Group:** The Jenkins user is added to the Docker group to execute Docker commands within the agent container.

 **Running the Jenkins Agent Container**

To run the Jenkins Agent container, use the following command:

```bash
docker run -d -it -v /var/run/docker.sock:/var/run/docker.sock --name NewAgent jenkins-agent
```

**Command Breakdown:** 

- **`docker run`**: This command is used to create and start a new Docker container from an image.
  
- **`-d`**: Runs the container in detached mode, meaning it runs in the background and does not block the terminal.

- **`-it`**: Combines `-i` (interactive) and `-t` (TTY) flags. This allows you to interact with the container via the terminal. It's especially useful when you want to execute commands inside the container.

- **`-v /var/run/docker.sock:/var/run/docker.sock`**: This option mounts the Docker socket from the host machine into the container. This allows the Jenkins Agent inside the container to communicate with the Docker daemon on the host. It is essential for running Docker commands within the Jenkins Agent container.

- **`--name NewAgent`**: This option names the container `NewAgent`. Naming the container makes it easier to manage and reference it in subsequent Docker commands.

- **`jenkins-agent`**: This specifies the Docker image to use for creating the container. In this case, `jenkins-agent` is the image name. Make sure this image is either available locally or can be pulled from a Docker registry.


### 3. Connect Jenkins with Agent via SSH

To connect Jenkins with the Agent using SSH:

#### Inside the Agent Container

```bash
docker exec -it -u root NewAgent bash # root user
docker exec -it  NewAgent bash        # jenkins user
```

1. **Generate SSH Key Pair:**
   ```bash
   ssh-keygen -t rsa -b 4096
   ```
   - The public key will be used to authenticate Jenkins with the agent.

2. **Copy Public Key:**
   ```bash
   cat ~/.ssh/id_rsa
   ```
   - Copy the private key and add it to the Jenkins server for SSH connectivity.

3. **Run SSH Service**
    **Note:** When you generate ssh key use `jenkins` user but when you start ssh service use `root` user 
    ```bash
    service ssh start
    ```

#### Inside Jenkins

1. **Add SSH Credentials:**
   - Navigate to Jenkins > Manage Jenkins > Manage Credentials > Global > Add Credentials.
   - Select "SSH Username with private key" and paste the private key generated on the agent.

2. **Configure Jenkins Node:**
   - Go to Jenkins > Manage Jenkins > Manage Nodes and Clouds > New Node.
   - Set up a new node with the agent's IP address and SSH credentials.

### 4. Create Credentials with Docker Hub Account
1. In Jenkins, go to **Manage Jenkins > Manage Credentials > Global > Add Credentials**.
2. Select **Username with password**, enter your Docker Hub username, password and ID, and save the credentials.

### 5. Create Pipeline with Schedule

#### Jenkinsfile for Test

```groovy
pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                sh 'echo hi'
            }
        }
        stage('Test') {
            steps {
                sh 'echo testing'
            }
            post {
                always {
                    sh 'echo results'
                }
            }
        }
    }
}
```

#### Jenkinsfile for Docker Build and Push

```groovy
pipeline {
    agent {label 'docker'}
    parameters {
        choice choices: ['dev', 'prod', 'nginx'], name: 'environment'
    }
    stages {
        stage('Preparation') {
            steps {
                git(
                    url: 'https://github.com/Bahnasy2001/spring-pet-clinic',
                    branch: 'main'
                )
            }
        }
        stage('CI') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    sh 'docker build . -t hassanbahnasy/spring-pet-clinic'
                    sh 'echo $PASSWORD | docker login -u $USERNAME --password-stdin'
                    sh 'docker push hassanbahnasy/spring-pet-clinic'
                }
            }
        }
    }
}
```

### Conclusion

This task demonstrated how to set up a Jenkins environment with Docker-in-Docker (DinD) and configure a Jenkins agent to work in tandem with the master container. By setting up Docker Hub credentials and creating pipelines, we explored basic CI/CD practices. The task highlights the flexibility and power of Jenkins in managing complex workflows and integrating with Docker to automate the deployment of applications.
