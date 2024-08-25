# Kubernetes Lab 2

![Static Badge](https://img.shields.io/badge/build-Ubuntu-brightgreen?style=flat&logo=ubuntu&label=Linux&labelColor=Orange&color=red) ![Static Badge](https://img.shields.io/badge/redis-7.4.0-orange?style=plastic&logo=redis&labelColor=red) ![Static Badge](https://img.shields.io/badge/Kubernetes-1.30-cyan?style=plastic&logo=kubernetes)

In this lab, you will explore Kubernetes Namespaces, manage Pods in specific namespaces, create a Deployment with resource limits in a custom namespace, and check the Nodes in your cluster.

## Table of Contents
1. [Checking Existing Namespaces](#1-checking-existing-namespaces)
2. [Listing Pods in the kube-system Namespace](#2-listing-pods-in-the-kube-system-namespace)
3. [Creating a Deployment in a Custom Namespace](#3-creating-a-deployment-in-a-custom-namespace)
4. [Checking the Number of Nodes](#4-checking-the-number-of-nodes)

## 1. Checking Existing Namespaces

To list all the namespaces in your Kubernetes cluster, use the following command:

```bash
kubectl get namespaces
```

This will show you how many namespaces currently exist in your system.

## 2. Listing Pods in the kube-system Namespace

To list all the Pods running in the `kube-system` namespace, use the following command:

```bash
kubectl get pods -n kube-system
```

This will display the number of Pods and their status within the `kube-system` namespace.

## 3. Creating a Deployment in a Custom Namespace

### Step 1: Create the `finance` Namespace

First, create the `finance` namespace where the Deployment will reside:

```bash
kubectl create namespace finance
```

### Step 2: Create the Deployment

Create a Deployment named `beta` using the Redis image, with the following specifications:

- **Namespace:** `finance`
- **Replicas:** 2
- **Resources Requests:**
  - CPU: 0.5 vCPU
  - Memory: 1G
- **Resources Limits:**
  - CPU: 1 vCPU
  - Memory: 2G

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: beta
  namespace: finance
spec:
  replicas: 2
  selector:
    matchLabels:
      app: redis
  template:
    metadata:
      labels:
        app: redis
    spec:
      containers:
      - name: redis
        image: redis
        resources:
          requests:
            memory: "1Gi"
            cpu: "500m"
          limits:
            memory: "2Gi"
            cpu: "1"
```

Apply the Deployment configuration:

```bash
kubectl apply -f beta-deployment.yml
```

### Step 3: Verify the Deployment

Check the status of the Deployment:

```bash
kubectl get deployments -n finance
```

## 4. Checking the Number of Nodes

To find out how many Nodes exist in your Kubernetes cluster, use the following command:

```bash
kubectl get nodes
```

This command lists all the Nodes in the system along with their status.

