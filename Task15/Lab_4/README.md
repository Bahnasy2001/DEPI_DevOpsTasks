# Kubernetes Lab 4

![Static Badge](https://img.shields.io/badge/build-Ubuntu-brightgreen?style=flat&logo=ubuntu&label=Linux&labelColor=Orange&color=red) ![Static Badge](https://img.shields.io/badge/nginx-1.18.0-grey?style=flat&logo=nginx&label=nginx&labelColor=darkgreen&color=grey) ![Static Badge](https://img.shields.io/badge/Kubernetes-1.30-cyan?style=plastic&logo=kubernetes)

This lab focuses on managing ConfigMaps, Secrets, multi-container Pods, Persistent Volumes, and environment variables within a Kubernetes cluster.

## Table of Contents
1. [Checking Existing ConfigMaps](#1-checking-existing-configmaps)
2. [Creating a ConfigMap and Using It](#creating-a-configmap-and-using-it)
3. [Managing Secrets](#managing-secrets)
4. [Deploying Pods with Secrets](#deploying-pods-with-secrets)
5. [Creating Multi-Container and InitContainers Pods](#creating-multi-container-and-initcontainers-pods)
6. [Echoing Environment Variables](#echoing-environment-variables)
7. [Managing Kubeconfig](#managing-kubeconfig)
8. [Working with Persistent Volumes](#working-with-persistent-volumes)

## 1. Checking Existing ConfigMaps

To find out how many ConfigMaps exist in the environment:

```bash
kubectl get configmaps --all-namespaces
```

## 2. Creating a ConfigMap and Using It

### Step 1: Create a ConfigMap

Create a YAML file named `webapp-config-map.yml` to define a ConfigMap named `webapp-config-map`:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: webapp-config-map
data:
  APP_COLOR: darkblue
```

Apply the YAML file:

```bash
kubectl apply -f webapp-config-map.yml
```

### Step 2: Create a Pod Using the ConfigMap

Create a YAML file named `webapp-color.yml` for deploying a Pod named `webapp-color` using the `nginx` image and the ConfigMap:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: webapp-color
spec:
  containers:
  - name: nginx
    image: nginx
    env:
    - name: APP_COLOR
      valueFrom:
        configMapKeyRef:
          name: webapp-config-map
          key: APP_COLOR
```

Apply the YAML file:

```bash
kubectl apply -f webapp-color.yml
```

## 3. Managing Secrets

### Step 1: Check Existing Secrets

To find out how many Secrets exist in the system:

```bash
kubectl get secrets --all-namespaces
```

To check how many secrets are defined in the `default-token` secret:

```bash
kubectl describe secret default-token -n default
```

### Step 2: Create a Secret

Create a YAML file named `db-secret.yml` to define a Secret named `db-secret`:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: db-secret
type: Opaque
data:
  MYSQL_DATABASE: c3FsMDE=  # sql01 base64 encoded
  MYSQL_USER: dXNlcjE=  # user1 base64 encoded
  MYSQL_PASSWORD: cGFzc3dvcmQ=  # password base64 encoded
  MYSQL_ROOT_PASSWORD: cGFzc3dvcmQxMjM=  # password123 base64 encoded
```

Apply the YAML file:

```bash
kubectl apply -f db-secret.yml
```

## 4. Deploying Pods with Secrets

### Step 1: Create the `db-pod`

Create a YAML file named `db-pod.yml` for deploying a Pod named `db-pod` using the `mysql:5.7` image:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: db-pod
spec:
  containers:
  - name: mysql
    image: mysql:5.7
    env:
    - name: MYSQL_DATABASE
      valueFrom:
        secretKeyRef:
          name: db-secret
          key: MYSQL_DATABASE
    - name: MYSQL_USER
      valueFrom:
        secretKeyRef:
          name: db-secret
          key: MYSQL_USER
    - name: MYSQL_PASSWORD
      valueFrom:
        secretKeyRef:
          name: db-secret
          key: MYSQL_PASSWORD
    - name: MYSQL_ROOT_PASSWORD
      valueFrom:
        secretKeyRef:
          name: db-secret
          key: MYSQL_ROOT_PASSWORD
```

Apply the YAML file:

```bash
kubectl apply -f db-pod.yml
```

### Step 2: Check the Pod Status

Check the status of the `db-pod`:

```bash
kubectl get pod db-pod
```

If the pod is not ready, it's likely because it is missing the necessary environment variables, which should be set by the Secret. Verify that the Secret was applied correctly and that the Pod is configured to use it.

## 5. Creating Multi-Container and InitContainers Pods

### Step 1: Create a Multi-Container Pod

Create a YAML file named `yellow.yml` for deploying a multi-container Pod named `yellow` with the specified containers:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: yellow
spec:
  containers:
  - name: lemon
    image: busybox
    command: ['sh', '-c', 'echo Hello from lemon && sleep 3600']
  - name: gold
    image: redis
```

Apply the YAML file:

```bash
kubectl apply -f yellow.yml
```

### Step 2: Create a Pod with an InitContainer

Create a YAML file named `red.yml` for deploying a Pod named `red` with an InitContainer that sleeps for 20 seconds:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: red
spec:
  initContainers:
  - name: init-myservice
    image: busybox
    command: ['sh', '-c', 'sleep 20']
  containers:
  - name: redis
    image: redis
```

Apply the YAML file:

```bash
kubectl apply -f red.yml
```

## 6. Echoing Environment Variables

### Step 1: Create a Pod to Print Environment Variables

Create a YAML file named `print-envars-greeting.yml` for deploying a Pod named `print-envars-greeting` using the `bash` image:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: print-envars-greeting
spec:
  containers:
  - name: print-env-container
    image: bash
    command: ["bash", "-c"]
    args:
    - 'echo "$(GREETING) $(COMPANY) $(GROUP)"'
    env:
    - name: GREETING
      value: "Welcome to"
    - name: COMPANY
      value: "DevOps"
    - name: GROUP
      value: "Industries"
```

Apply the YAML file:

```bash
kubectl apply -f print-envars-greeting.yml
```

### Step 2: Check the Pod Logs

To check the output of the environment variables, use:

```bash
kubectl logs -f print-envars-greeting
```

## 7. Managing Kubeconfig

### Step 1: Locate the Default Kubeconfig File

The default kubeconfig file is typically located at:

```bash
~/.kube/config
```

### Step 2: Check the Number of Clusters and Current Context

To find out how many clusters are defined in the default kubeconfig file:

```bash
kubectl config view -o jsonpath='{.clusters[*].name}'
```

To identify the user configured in the current context:

```bash
kubectl config view -o jsonpath='{.contexts[?(@.name=="<current-context>")].context.user}'
```

## 8. Working with Persistent Volumes

### Step 1: Create a Persistent Volume

Create a YAML file named `pv-log.yml` for creating a Persistent Volume with the given specification:

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-log
spec:
  capacity:
    storage: 100Mi
  accessModes:
    - ReadWriteMany
  hostPath:
    path: /pv/log
```

Apply the YAML file:

```bash
kubectl apply -f pv-log.yml
```

### Step 2: Create a Persistent Volume Claim

Create a YAML file named `claim-log-1.yml` for creating a Persistent Volume Claim:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: claim-log-1
spec:
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 50Mi
```

Apply the YAML file:

```bash
kubectl apply -f claim-log-1.yml
```

### Step 3: Create a WebApp Pod Using the Persistent Volume Claim

Create a YAML file named `webapp-pvc.yml` for deploying a webapp Pod that uses the Persistent Volume Claim as its storage:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: webapp
spec:
  containers:
  - name: nginx
    image: nginx
    volumeMounts:
    - mountPath: /var/log/nginx
      name: log-volume
  volumes:
  - name: log-volume
    persistentVolumeClaim:
      claimName: claim-log-1
```

Apply the YAML file:

```bash
kubectl apply -f webapp-pvc.yml
```


