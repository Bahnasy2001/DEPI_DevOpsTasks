# Lab 5: HAProxy Ingress and Backend Setup

![Static Badge](https://img.shields.io/badge/build-Ubuntu-brightgreen?style=flat&logo=ubuntu&label=Linux&labelColor=Orange&color=red) ![Static Badge](https://img.shields.io/badge/nginx-1.18.0-grey?style=flat&logo=nginx&label=nginx&labelColor=darkgreen&color=grey) ![Static Badge](https://img.shields.io/badge/Kubernetes-1.30-cyan?style=plastic&logo=kubernetes)

### Overview

This Kubernetes deployment consists of two primary components:

* **Backend Service:** A simple echo server application that handles incoming requests and responds with a basic message.
* **Ingress Controller:** An Haproxy-based Ingress controller that acts as a gateway for external traffic, routing requests to the backend service.

### Deployment Structure

1. **Namespace:** `haproxy-controller-devops` is created to isolate the deployment.
2. **Service Account:** `haproxy-service-account-devops` is used to provide permissions for the Ingress controller.
3. **ClusterRole and ClusterRoleBinding:** These are used to grant the service account necessary permissions to access Kubernetes resources.
4. **Backend Deployment:** Deploys the backend service using the `gcr.io/google_containers/defaultbackend:1.0` image.
5. **Backend Service:** Exposes the backend deployment as a Kubernetes Service.
6. **Ingress Controller Deployment:** Deploys the Haproxy Ingress controller.
7. **Ingress Service:** Exposes the Ingress controller as a NodePort Service for external access.

### Components and Their Roles

* **Backend Service:** Handles incoming requests and processes them.
* **Ingress Controller (Haproxy):**
    - Acts as a load balancer and gateway.
    - Routes traffic to the backend service based on configuration.
    - Provides features like SSL/TLS termination, health checks, and more.

### 1. Create a Namespace
Create a namespace named `haproxy-controller-devops`:
```bash
kubectl create namespace haproxy-controller-devops
```

### 2. Create a ServiceAccount
Create a ServiceAccount named `haproxy-service-account-devops` in the `haproxy-controller-devops` namespace:
```bash
kubectl create serviceaccount haproxy-service-account-devops -n haproxy-controller-devops
```

### 3. Create a ClusterRole
Create a ClusterRole named `haproxy-cluster-role-devops` with the specified permissions:
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: haproxy-cluster-role-devops
rules:
- apiGroups: [""]  # Existing rules for core resources
  resources: ["configmaps", "secrets", "endpoints", "nodes", "pods", "services", "namespaces", "events", "serviceaccounts"]
  verbs: ["get", "list", "watch", "create", "patch", "update"]
- apiGroups: ["apiextensions.k8s.io"]  # Added rule for apiextensions.k8s.io group (unchanged)
  resources: ["customresourcedefinitions"]  # Limit access to customresourcedefinitions (unchanged)
  verbs: ["get", "list"]  # Grant only get and list verbs (unchanged)
# Added rules for networking.k8s.io and discovery.k8s.io API groups
- apiGroups: ["networking.k8s.io"]
  resources: ["ingresses", "ingressclasses", "endpointslices"]  # Resources required by Ingress controller
  verbs: ["get", "list", "watch"]  # Grant get, list, and watch verbs
- apiGroups: ["discovery.k8s.io"]
  resources: ["endpointslices"]  # Resource required for service discovery
  verbs: ["get", "list", "watch"]  # Grant get, list, and watch verbs
```
```bash
kubectl apply -f haproxy-cluster-role-devops.yml
```

### 4. Create a ClusterRoleBinding
Create a ClusterRoleBinding named `haproxy-cluster-role-binding-devops`:
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: haproxy-cluster-role-binding-devops
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: haproxy-cluster-role-devops
subjects:
- kind: ServiceAccount
  name: haproxy-service-account-devops
  namespace: haproxy-controller-devops
```
```bash
kubectl apply -f haproxy-cluster-role-binding-devops.yaml
```

### 5. Create a Backend Deployment
Create a Deployment named `backend-deployment-devops`:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend-deployment-devops
  namespace: haproxy-controller-devops
  labels:
    run: ingress-default-backend
spec:
  replicas: 1
  selector:
    matchLabels:
      run: ingress-default-backend
  template:
    metadata:
      labels:
        run: ingress-default-backend
    spec:
      containers:
      - name: backend-container-devops
        image: gcr.io/google_containers/defaultbackend:1.0
        ports:
        - containerPort: 8080
```
```bash
kubectl apply -f backend-deployment-devops.yml
```

### 6. Create a Service for the Backend
Create a Service named `service-backend-devops`:
```yaml
apiVersion: v1
kind: Service
metadata:
  name: service-backend-devops
  namespace: haproxy-controller-devops
  labels:
    run: ingress-default-backend
spec:
  selector:
    run: ingress-default-backend
  ports:
  - name: port-backend
    protocol: TCP
    port: 8080
    targetPort: 8080
```
```bash
kubectl apply -f service-backend-devops.yml
```

### 7. Create a Frontend Deployment
Create a Deployment named `haproxy-ingress-devops`:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: haproxy-ingress-devops
  namespace: haproxy-controller-devops
spec:
  replicas: 1
  selector:
    matchLabels:
      run: haproxy-ingress
  template:
    metadata:
      labels:
        run: haproxy-ingress
    spec:
      serviceAccountName: haproxy-service-account-devops
      containers:
      - name: ingress-container-devops
        image: haproxytech/kubernetes-ingress
        args:
        - --default-backend-service=haproxy-controller-devops/service-backend-devops
        resources:
          requests:
            memory: "50Mi"
            cpu: "500m"
        livenessProbe:
          httpGet:
            path: /healthz
            port: 1024
        ports:
        - name: http
          containerPort: 8080
        - name: https
          containerPort: 8443
        - name: stat
          containerPort: 1024
        env:
        - name: TZ
          value: Etc/UTC
        - name: POD_NAME
          valueFrom:
            fieldRef:
              fieldPath: metadata.name
        - name: POD_NAMESPACE
          valueFrom:
            fieldRef:
              fieldPath: metadata.namespace
```
```bash
kubectl apply -f haproxy-ingress-devops.yml
```

### 8. Create a Service for the Frontend
Create a Service named `ingress-service-devops`:
```yaml
apiVersion: v1
kind: Service
metadata:
  name: ingress-service-devops
  namespace: haproxy-controller-devops
  labels:
    run: haproxy-ingress

spec:
  selector:
    run: haproxy-ingress
  type: NodePort
  ports:
  - name: http
    protocol: TCP
    port: 8080
    targetPort: 8080
    nodePort: 32456
  - name: https
    protocol: TCP
    port: 8443
    targetPort: 8443
    nodePort: 32567
  - name: stat
    protocol: TCP
    port: 1024
    targetPort: 1024
    nodePort: 32678
```
```bash
kubectl apply -f ingress-service-devops.yml
```


### Accessing the Application

To access the application, use the following URL:

```
http://<NodeIP>:32678
```

Replace `<NodeIP>` with the actual IP address of your Kubernetes node.


