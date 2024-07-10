#!/bin/bash

# Update the apt package index and install packages to allow apt to use a repository over HTTPS
sudo apt-get update
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

# Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Add Docker repository
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# Update the apt package index again
sudo apt-get update

# Install the latest version of Docker CE (Community Edition)
sudo apt-get install -y docker-ce

# Verify that Docker CE is installed correctly by running the hello-world image
sudo docker run hello-world

# Optional: Add the current user to the Docker group to run Docker commands without sudo
sudo usermod -aG docker $USER

echo "Docker installation completed. Please log out and log back in to use Docker without sudo."
