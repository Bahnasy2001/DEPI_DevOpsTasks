# Task15: Kubernetes Labs 

![Static Badge](https://img.shields.io/badge/build-Ubuntu-brightgreen?style=flat&logo=ubuntu&label=Linux&labelColor=Orange&color=red) ![Static Badge](https://img.shields.io/badge/Docker-27.0.3-skyblue?style=flat&logo=docker&label=Docker) ![Static Badge](https://img.shields.io/badge/Linux-Task15-Orange?style=flat&label=DevOps&labelColor=blue&color=gray) ![Static Badge](https://img.shields.io/badge/Kubernetes-1.30-cyan?style=plastic&logo=kubernetes)

## Table of Contents

- [Lab 1: Kubernetes Basics](#lab-1-kubernetes-basics)
- [Lab 2: Namespaces, Resource Management, and Deployments](#lab-2-namespaces-resource-management-and-deployments)
- [Lab 3: DaemonSets, Pods, and Services](#lab-3-daemonsets-pods-and-services)
- [Lab 4: ConfigMaps, Secrets, and Persistent Volumes](#lab-4-configmaps-secrets-and-persistent-volumes)
- [Lab 5: RBAC, Deployments, and Ingress Controllers](#lab-5-rbac-deployments-and-ingress-controllers)

---

### Lab 1: Kubernetes Basics

**Objective:**  
This lab introduces the foundational concepts of Kubernetes. You will learn how to set up a Kubernetes cluster using Minikube, create Pods using both `kubectl` commands and YAML definitions, and manage ReplicaSets and Deployments.

**Key Topics:**
- Installing Minikube and Kubectl
- Creating and managing Pods
- Working with ReplicaSets and Deployments
- Scaling Deployments

**Location:** [Lab 1 README](./Lab_1/README.md)

---

### Lab 2: Namespaces, Resource Management, and Deployments

**Objective:**  
In this lab, you will explore Kubernetes namespaces and how they are used for resource segmentation. You'll also learn to create deployments with resource requests and limits and check system details like existing namespaces and nodes.

**Key Topics:**
- Working with Namespaces
- Creating Deployments with resource requests and limits
- Managing and monitoring system resources

**Location:** [Lab 2 README](./Lab_2/README.md)

---

### Lab 3: DaemonSets, Pods, and Services

**Objective:**  
This lab covers the management of DaemonSets, Pods, and Services in Kubernetes. You'll deploy DaemonSets, create services to expose your applications, and understand how to interact with applications running in the cluster.

**Key Topics:**
- Deploying and managing DaemonSets
- Creating and exposing Pods with Services
- Interacting with applications via Services

**Location:** [Lab 3 README](./Lab_3/README.md)

---

### Lab 4: ConfigMaps, Secrets, and Persistent Volumes

**Objective:**  
In this lab, you'll work with ConfigMaps, Secrets, and Persistent Volumes to manage configuration data, sensitive information, and persistent storage in Kubernetes. You'll also explore multi-container Pods and environment variable management.

**Key Topics:**
- Creating and using ConfigMaps and Secrets
- Managing Persistent Volumes and Claims
- Working with multi-container Pods

**Location:** [Lab 4 README](./Lab_4/README.md)

---

### Lab 5: RBAC, Deployments, and Ingress Controllers

**Objective:**  
The final lab focuses on Role-Based Access Control (RBAC), advanced deployments, and Ingress Controllers. You'll set up service accounts, define roles and role bindings, and deploy backend and frontend services using HAProxy as the Ingress Controller.

**Key Topics:**
- Setting up RBAC with ClusterRoles and ClusterRoleBindings
- Deploying services and managing their exposure with Ingress Controllers
- Working with service accounts in Kubernetes

**Location:** [Lab 5 README](./Lab_5/README.md)

---

## Getting Started

To start working with these labs, navigate to each lab's directory and follow the instructions provided in the respective README file. Make sure you have a Kubernetes cluster (like Minikube) set up and configured before you begin.

## Prerequisites

- Basic understanding of Kubernetes concepts
- A Kubernetes cluster (Minikube recommended)
- `kubectl` command-line tool installed
- Access to a terminal or command-line interface
