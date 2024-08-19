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

