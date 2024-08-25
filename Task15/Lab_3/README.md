# Kubernetes Lab 3

![Static Badge](https://img.shields.io/badge/build-Ubuntu-brightgreen?style=flat&logo=ubuntu&label=Linux&labelColor=Orange&color=red) ![Static Badge](https://img.shields.io/badge/nginx-1.18.0-grey?style=flat&logo=nginx&label=nginx&labelColor=darkgreen&color=grey) ![Static Badge](https://img.shields.io/badge/Kubernetes-1.30-cyan?style=plastic&logo=kubernetes)

In this lab, you will explore DaemonSets, deploy Pods and Services using YAML files, interact with static Pods, and manage networking within your Kubernetes cluster.

## Table of Contents
1. [Checking DaemonSets in the Cluster](#1-checking-daemonsets-in-the-cluster)
2. [Inspecting the kube-proxy DaemonSet](#2-inspecting-the-kube-proxy-daemonset)
3. [Deploying FluentD Logging DaemonSet](#3-deploying-fluentd-logging-daemonset)
4. [Deploying and Testing Backend Services](#4-deploying-and-testing-backend-services)
5. [Deploying Web Application and Exposing it](#5-deploying-web-application-and-exposing-it)
6. [Checking Static Pods in the Cluster](#6-checking-static-pods-in-the-cluster)

## 1. Checking DaemonSets in the Cluster

To find out how many DaemonSets are created in the cluster across all namespaces, use the following command:

```bash
kubectl get daemonsets --all-namespaces
```

This command will list all the DaemonSets in every namespace.

## 2. Inspecting the kube-proxy DaemonSet

To find out which DaemonSets exist in the `kube-system` namespace, run:

```bash
kubectl get daemonsets -n kube-system
```

To check the image used by the Pods deployed by the `kube-proxy` DaemonSet, use:

```bash
kubectl describe daemonset kube-proxy -n kube-system | grep "Image:"
```

## 3. Deploying FluentD Logging DaemonSet

Deploy a DaemonSet named `elasticsearch` for FluentD logging with the following specifications:

- **Namespace:** `kube-system`
- **Image:** `k8s.gcr.io/fluentd-elasticsearch:1.20`

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: elasticsearch
  namespace: kube-system
spec:
  selector:
    matchLabels:
      name: fluentd-elasticsearch
  template:
    metadata:
      labels:
        name: fluentd-elasticsearch
    spec:
      containers:
      - name: fluentd-elasticsearch
        image: k8s.gcr.io/fluentd-elasticsearch:1.20
        resources:
          limits:
            memory: 200Mi
            cpu: 100m
          requests:
            memory: 200Mi
            cpu: 100m
```

Apply the configuration:

```bash
kubectl apply -f fluentd-daemonset.yml
```

## 4. Deploying and Testing Backend Services

### Step 1: Deploy a Pod

Create a YAML file named `nginx-pod.yml` for deploying a Pod named `nginx-pod` using the `nginx:alpine` image with the labels `tier=backend`:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
  labels:
    tier: backend
spec:
  containers:
  - name: nginx
    image: nginx:alpine
```

Apply the YAML file:

```bash
kubectl apply -f nginx-pod.yml
```

### Step 2: Deploy a Test Pod

Create a YAML file named `test-pod.yml` for deploying a test Pod using the `nginx:alpine` image:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: test-pod
spec:
  containers:
  - name: nginx
    image: nginx:alpine
```

Apply the YAML file:

```bash
kubectl apply -f test-pod.yml
```

### Step 3: Create a Backend Service

Create a YAML file named `backend-service.yml` to expose the backend application as a service `backend-service` within the cluster on port 80:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: backend-service
spec:
  selector:
    tier: backend
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
```

Apply the YAML file:

```bash
kubectl apply -f backend-service.yml
```

### Step 4: Curl the Backend Service

From the test Pod, try to curl the `backend-service`:

```bash
kubectl exec test-pod -- curl backend-service
```

Record the response from the `curl` command.

## 5. Deploying Web Application and Exposing it

### Step 1: Deploy the Web Application

Create a YAML file named `web-app.yml` for deploying a Deployment named `web-app` using the `nginx` image with 2 replicas:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: web-app
  template:
    metadata:
      labels:
        app: web-app
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80
```

Apply the YAML file:

```bash
kubectl apply -f web-app.yml
```

### Step 2: Expose the Web Application

Create a YAML file named `web-app-service.yml` to expose the `web-app` Deployment as a service `web-app-service` on port 80 and nodePort 30082:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-app-service
spec:
  selector:
    app: web-app
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
    nodePort: 30082
  type: NodePort
```

Apply the YAML file:

```bash
kubectl apply -f web-app-service.yml
```

### Step 3: Access the Web Application

Access the web app from the node using the NodePort:

```bash
curl <Node_IP>:30082
```

```bash
curl 192.168.103.2:30082
```

![Web-app](Lab_3/Lab03_Part4.png)

## 6. Checking Static Pods in the Cluster

### Step 1: Check the Number of Static Pods

To find out how many static Pods exist in the cluster across all namespaces:

```bash
kubectl get pods --all-namespaces --field-selector=status.phase=Running | grep static
```

### Step 2: Identify Nodes with Static Pods

To identify the Nodes on which the static Pods are currently running:

```bash
kubectl get pods --all-namespaces -o wide --field-selector=status.phase=Running | grep static
```
