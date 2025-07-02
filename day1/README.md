# Day 1: Kubernetes Setup in GitHub Codespaces

## Overview
Setting up Kubernetes in GitHub Codespaces using Kind (Kubernetes in Docker) without systemctl commands.

## Prerequisites
- GitHub Codespaces environment
- Basic terminal knowledge

## Step-by-Step Setup

### 1. Check if kubectl is Already Installed
```bash
command -v kubectl
```
**Expected output:** Path to kubectl binary or nothing if not installed

### 2. Install kubectl (if not present)
```bash
sudo apt-get update
sudo apt-get install -y kubectl
```

### 3. Verify kubectl Installation
```bash
kubectl version --client --short
```
**Expected output:** Client version information

### 4. Check if kind is Already Installed
The `kind` command is used to create and manage Kubernetes clusters in Docker.
```bash
command -v kind
```
**Expected output:** Path to kind binary or nothing if not installed

### 5. Install kind (if not present)
```bash
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.23.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
```

### 6. Verify kind Installation
```bash
kind version
```
**Expected output:** Kind version information

### 7. Check Docker Status (Alternative to systemctl)
```bash
docker info
```
**Expected output:** Docker system information
**If error:** Docker daemon is not running

### 8. Start Docker (if needed) - Codespaces Alternative
```bash
sudo dockerd &
```
**Note:** In Codespaces, Docker is usually pre-configured and running

### 9. Verify Docker is Working
```bash
docker ps
```
**Expected output:** List of running containers (may be empty)

### 10. Check Existing Kind Clusters
```bash
kind get clusters
```
**Expected output:** List of clusters or "No kind clusters found"

### 11. Create Kubernetes Cluster
```bash
kind create cluster --name my-cluster
```
**Expected output:** Cluster creation progress and success message

### 12. Verify Cluster is Running
```bash
kubectl cluster-info
```
**Expected output:** Cluster endpoint information

### 13. Check Cluster Nodes
```bash
kubectl get nodes
```
**Expected output:** Node status (should show Ready)

### 14. Wait for All Nodes to be Ready
```bash
kubectl wait --for=condition=Ready nodes --all --timeout=300s
```
**Expected output:** Confirmation that nodes are ready

### 15. Check System Pods
```bash
kubectl get pods -A
```
**Expected output:** All system pods in various namespaces

## Troubleshooting

### Docker Issues
If docker commands fail:
```bash
# Check if Docker daemon is running
ps aux | grep docker

# Check Docker socket
ls -la /var/run/docker.sock
```

### Kind Cluster Issues
If cluster creation fails:
```bash
# Delete existing cluster
kind delete cluster --name my-cluster

# Clean Docker resources
docker system prune -f

# Recreate cluster
kind create cluster --name my-cluster
```

### kubectl Connection Issues
```bash
# Check kubeconfig
kubectl config view

# Check current context
kubectl config current-context

# Set context to kind cluster
kubectl config use-context kind-my-cluster
```

## Verification Commands

### Test Deployment
```bash
# Create a test deployment
kubectl create deployment hello-world --image=nginx

# Check deployment status
kubectl get deployments

# Check pods
kubectl get pods
```

### Clean Up
```bash
# Delete test deployment
kubectl delete deployment hello-world

# Delete kind cluster (when done)
kind delete cluster --name my-cluster
```

## Notes for Codespaces
- Docker is pre-installed and usually running
- No need for systemctl commands
- Limited resources compared to full VM
- Port forwarding required for external access

## Next Steps
- Day 2: Basic Kubernetes workloads
- Day 3: Services and networking
- Day 4: ConfigMaps and Secrets