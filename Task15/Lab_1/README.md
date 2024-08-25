# Kubernetes Lab 1

![Static Badge](https://img.shields.io/badge/build-Ubuntu-brightgreen?style=flat&logo=ubuntu&label=Linux&labelColor=Orange&color=red) ![Static Badge](https://img.shields.io/badge/nginx-1.18.0-grey?style=flat&logo=nginx&label=nginx&labelColor=darkgreen&color=grey) ![Static Badge](https://img.shields.io/badge/Kubernetes-1.30-cyan?style=plastic&logo=kubernetes)


This lab guides you through the process of setting up a Kubernetes cluster using Minikube, creating Pods, ReplicaSets, and Deployments, and managing them with kubectl commands and YAML configuration files.

## Table of Contents
1. [Setup Kubernetes Cluster](#setup-kubernetes-cluster)
2. [Creating a Pod](#creating-a-pod)
   - Using kubectl command
   - Using YAML configuration
3. [Creating a ReplicaSet](#creating-a-replicaset)
   - Scaling the ReplicaSet
4. [Creating a Deployment](#creating-a-deployment)
   - Rolling Update and Rollback
   - Creating a Deployment with Custom Labels

## 1. Setup Kubernetes Cluster

### Install Minikube

To install Minikube and set up your Kubernetes cluster, run the following commands:

```bash
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64
minikube start
snap install kubectl --classic
kubectl get nodes
```

This will install Minikube, start your Kubernetes cluster, and verify the installation by checking the nodes.

## 2. Creating a Pod

### Using kubectl command

Create a Pod named `nginx-po` with the nginx image:

```bash
kubectl run nginx-po --image=nginx
```

To view details about the Pod:

```bash
kubectl describe po nginx-po
```

To check the Pod status:

```bash
kubectl get pods
```

### Using YAML Configuration

Create a Pod named `nginx-pod` using the following YAML configuration:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
  labels:
    app: nginx
spec:
  containers:
    - name: nginx
      image: nginx:1.14.2
      ports:
        - containerPort: 80
```

Apply the configuration:

```bash
kubectl create -f pod-nginx.yml
```

To update the Pod configuration:

```bash
kubectl replace -f pod-nginx.yml --force
# or
kubectl apply -f pod-nginx.yml
```

## 3. Creating a ReplicaSet

Create a ReplicaSet named `nginx-replicaset` using the following YAML configuration:

```yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: nginx-replicaset
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: nginx
          image: nginx:1.14.2
          ports:
            - containerPort: 80
```

Apply the configuration:

```bash
kubectl apply -f replica.yml
```

### Scaling the ReplicaSet

Scale the ReplicaSet to 6 replicas:

```bash
kubectl scale --replicas=6 -f replica.yml
```

Or scale it to 4 replicas:

```bash
kubectl scale --replicas=4 replicaset nginx-replicaset
```

## 4. Creating a Deployment

### Creating the Deployment

Create a Deployment named `nginx-deployment` using the following YAML configuration:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: nginx
          image: nginx:1.14.2
          ports:
            - containerPort: 80
```

Apply the configuration:

```bash
kubectl apply -f deployment.yml
# or use the kubectl command:
kubectl create deployment nginx-deployment --image=nginx:1.14.2 --replicas=3
```

### Rolling Update and Rollback

Update the image in the Deployment:

```bash
kubectl set image deployment/nginx-deployment nginx=nginx --record
# or modify the YAML file and re-apply it.
```

To rollback the Deployment:

```bash
kubectl rollout undo deployment/nginx-deployment
```

Check the current image:

```bash
kubectl describe deployment nginx-deployment | grep "Image:"
```

### Creating a Deployment with Custom Labels

Create a Deployment with custom labels:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx-app
    type: front-end
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx-app
  template:
    metadata:
      labels:
        app: nginx-app
        type: front-end
    spec:
      containers:
      - name: nginx-container
        image: nginx:latest
```

Apply the configuration:

```bash
kubectl apply -f nginx-deployment.yml
```

Check the status of the Deployment:

```bash
kubectl get deployments
```
