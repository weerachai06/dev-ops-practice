# DevContainer for Kubernetes Practice

This devcontainer provides a complete Kubernetes development environment for GitHub Codespaces.

## What's Included

### Tools
- **Docker**: Container runtime
- **kubectl**: Kubernetes command-line tool
- **kind**: Kubernetes in Docker (for local clusters)
- **YAML/JSON**: Language support and validation

### VS Code Extensions
- **Kubernetes**: Full Kubernetes support with IntelliSense
- **YAML**: Syntax highlighting and validation
- **Docker**: Container management
- **GitHub Copilot**: AI code assistance

### Pre-configured Aliases
- `k` = `kubectl`
- `kgp` = `kubectl get pods`
- `kgs` = `kubectl get services`
- `kgd` = `kubectl get deployments`
- `kga` = `kubectl get all`
- `kdp` = `kubectl describe pod`
- `kds` = `kubectl describe service`
- `kdd` = `kubectl describe deployment`
- `kl` = `kubectl logs`
- `kpf` = `kubectl port-forward`
- `kex` = `kubectl exec -it`

### Kind Aliases
- `kc-create` = `kind create cluster`
- `kc-delete` = `kind delete cluster`
- `kc-list` = `kind get clusters`

## Quick Start

1. **Create Kubernetes Cluster**
   ```bash
   kind create cluster
   ```

2. **Verify Cluster**
   ```bash
   kubectl get nodes
   # or using alias
   k get nodes
   ```

3. **Deploy Sample Application**
   ```bash
   k create deployment nginx --image=nginx --replicas=3
   k expose deployment nginx --port=80
   k get all
   ```

4. **Test Port Forwarding**
   ```bash
   k port-forward service/nginx 8080:80
   ```

## Port Forwarding

The devcontainer is pre-configured to forward common ports:
- **8080-8085**: For Kubernetes services
- Ports automatically open in VS Code when forwarded

## Directory Structure

```
/workspaces/dev-ops-practice/
├── .devcontainer/           # DevContainer configuration
├── day1-kube/              # Day 1 materials
├── day2-advanced/          # Advanced Kubernetes topics
├── day3-networking/        # Networking and services
├── day4-storage/           # Storage and persistence
└── examples/               # Example applications
```

## Troubleshooting

### If Docker is not running:
```bash
sudo dockerd &
```

### If kind cluster fails to create:
```bash
# Clean up and retry
kind delete cluster
docker system prune -f
kind create cluster
```

### If kubectl can't connect:
```bash
# Check cluster status
kind get clusters
kubectl cluster-info
```

### Reset everything:
```bash
# Delete cluster and start fresh
kind delete cluster
kind create cluster
```

## Additional Commands

### Cluster Management
```bash
# Create cluster with custom name
kind create cluster --name my-cluster

# Delete specific cluster  
kind delete cluster --name my-cluster

# List all clusters
kind get clusters
```

### Resource Monitoring
```bash
# Watch pods in real-time
k get pods -w

# Get resource usage (requires metrics-server)
k top nodes
k top pods
```

### Debugging
```bash
# Get detailed pod information
k describe pod <pod-name>

# Get pod logs
k logs <pod-name>

# Execute commands in pod
k exec -it <pod-name> -- bash
```

Enjoy your Kubernetes learning journey! 🚀
