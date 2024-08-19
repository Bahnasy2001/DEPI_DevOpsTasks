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
