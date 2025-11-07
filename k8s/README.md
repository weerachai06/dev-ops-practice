# Kubernetes Learning Path for GitHub Codespaces

## Prerequisites
- Basic understanding of containers and Docker
- Familiarity with command line/terminal
- GitHub account with Codespaces access

## Setup: Configuring Your Codespace for Kubernetes

### 1. Create a `.devcontainer/devcontainer.json` file:
```json
{
  "name": "Kubernetes Learning Environment",
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
  "features": {
    "ghcr.io/devcontainers/features/docker-in-docker:2": {},
    "ghcr.io/devcontainers/features/kubectl-helm-minikube:1": {
      "version": "latest",
      "helm": "latest",
      "minikube": "latest"
    }
  },
  "postCreateCommand": "minikube start --driver=docker",
  "customizations": {
    "vscode": {
      "extensions": [
        "ms-kubernetes-tools.vscode-kubernetes-tools"
      ]
    }
  }
}
```

---

## Phase 1: Kubernetes Fundamentals (Week 1-2)

### Module 1: Understanding Kubernetes Architecture
**Learning Objectives:**
- Understand what Kubernetes is and why it's used
- Learn about the control plane and worker nodes
- Understand the role of etcd, API server, scheduler, and kubelet

**Hands-on Exercise:**
```bash
# Start minikube
minikube start

# View cluster info
kubectl cluster-info

# Check node status
kubectl get nodes

# Explore the components
kubectl get pods -n kube-system
```

### Module 2: Pods - The Basic Unit
**Learning Objectives:**
- Understand what a Pod is
- Create and manage Pods
- Learn about Pod lifecycle

**Hands-on Exercise:**
```bash
# Create a simple nginx pod
kubectl run nginx --image=nginx

# Get pod details
kubectl get pods
kubectl describe pod nginx

# View logs
kubectl logs nginx

# Execute commands in pod
kubectl exec -it nginx -- /bin/bash

# Delete the pod
kubectl delete pod nginx
```

**Practice Task:** Create a pod using a YAML file:
```yaml
# pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-app
  labels:
    app: myapp
spec:
  containers:
  - name: app-container
    image: nginx
    ports:
    - containerPort: 80
```

```bash
kubectl apply -f pod.yaml
```

---

## Phase 2: Workload Resources (Week 3-4)

### Module 3: Deployments
**Learning Objectives:**
- Understand Deployments and their benefits
- Learn about ReplicaSets
- Perform rolling updates and rollbacks

**Hands-on Exercise:**
```bash
# Create a deployment
kubectl create deployment my-nginx --image=nginx --replicas=3

# Scale the deployment
kubectl scale deployment my-nginx --replicas=5

# Update the image
kubectl set image deployment/my-nginx nginx=nginx:1.21

# Check rollout status
kubectl rollout status deployment/my-nginx

# View rollout history
kubectl rollout history deployment/my-nginx

# Rollback to previous version
kubectl rollout undo deployment/my-nginx
```

**Practice Task:** Create a deployment YAML with multiple replicas and perform a rolling update.

### Module 4: Services
**Learning Objectives:**
- Understand Service types (ClusterIP, NodePort, LoadBalancer)
- Learn about service discovery
- Expose applications

**Hands-on Exercise:**
```bash
# Expose deployment as a service
kubectl expose deployment my-nginx --port=80 --type=NodePort

# Get service details
kubectl get services
kubectl describe service my-nginx

# Access the service using minikube
minikube service my-nginx --url

# Test with curl
curl $(minikube service my-nginx --url)
```

**Practice Task:** Create services of different types and understand their differences.

---

## Phase 3: Configuration and Storage (Week 5-6)

### Module 5: ConfigMaps and Secrets
**Learning Objectives:**
- Manage configuration data
- Handle sensitive information
- Inject configuration into Pods

**Hands-on Exercise:**
```bash
# Create a ConfigMap
kubectl create configmap app-config --from-literal=APP_ENV=production

# Create a Secret
kubectl create secret generic db-secret --from-literal=password=mysecretpassword

# View them
kubectl get configmaps
kubectl get secrets
kubectl describe configmap app-config
```

**Practice Task:** Create a Pod that uses ConfigMap for environment variables and Secret for mounting files.

### Module 6: Persistent Volumes
**Learning Objectives:**
- Understand storage in Kubernetes
- Work with PersistentVolumes and PersistentVolumeClaims
- Use different storage classes

**Hands-on Exercise:**
```bash
# Create a PersistentVolumeClaim
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: my-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
EOF

# Check PVC status
kubectl get pvc
```

---

## Phase 4: Advanced Concepts (Week 7-8)

### Module 7: Namespaces and Resource Quotas
**Learning Objectives:**
- Organize resources with namespaces
- Set resource limits
- Implement quotas

**Hands-on Exercise:**
```bash
# Create a namespace
kubectl create namespace dev

# Deploy to specific namespace
kubectl create deployment nginx --image=nginx -n dev

# Set default namespace
kubectl config set-context --current --namespace=dev

# View resources in all namespaces
kubectl get pods --all-namespaces
```

### Module 8: Health Checks and Probes
**Learning Objectives:**
- Implement liveness probes
- Implement readiness probes
- Understand startup probes

**Practice Task:** Create a deployment with all three probe types.

### Module 9: Jobs and CronJobs
**Learning Objectives:**
- Run batch jobs
- Schedule recurring tasks

**Hands-on Exercise:**
```bash
# Create a job
kubectl create job hello --image=busybox -- echo "Hello Kubernetes"

# Create a cronjob
kubectl create cronjob hello --image=busybox --schedule="*/1 * * * *" -- echo "Hello"

# View jobs and cronjobs
kubectl get jobs
kubectl get cronjobs
```

---

## Phase 5: Networking and Security (Week 9-10)

### Module 10: Ingress
**Learning Objectives:**
- Understand Ingress controllers
- Configure HTTP routing
- Set up TLS/SSL

**Hands-on Exercise:**
```bash
# Enable ingress addon in minikube
minikube addons enable ingress

# Create an ingress resource
# (Create YAML file for ingress)
```

### Module 11: Network Policies
**Learning Objectives:**
- Control pod-to-pod communication
- Implement security policies

### Module 12: RBAC (Role-Based Access Control)
**Learning Objectives:**
- Create service accounts
- Define roles and role bindings
- Implement security best practices

---

## Phase 6: Observability (Week 11-12)

### Module 13: Monitoring and Logging
**Hands-on Exercise:**
```bash
# Enable metrics server
minikube addons enable metrics-server

# View resource usage
kubectl top nodes
kubectl top pods

# View logs from multiple pods
kubectl logs -l app=myapp
```

### Module 14: Debugging
**Learning Objectives:**
- Troubleshoot pod issues
- Debug networking problems
- Analyze cluster events

**Hands-on Exercise:**
```bash
# Check events
kubectl get events --sort-by='.lastTimestamp'

# Describe resources for troubleshooting
kubectl describe pod <pod-name>

# Check logs with previous container
kubectl logs <pod-name> --previous
```

---

## Practical Projects

### Project 1: Simple Web Application
Deploy a multi-tier web application with:
- Frontend (React/Vue)
- Backend API (Node.js/Python)
- Database (PostgreSQL/MySQL)
- Proper service exposure

### Project 2: Microservices Application
Build a microservices application with:
- Multiple interconnected services
- Service discovery
- ConfigMaps for configuration
- Ingress for routing

### Project 3: CI/CD Pipeline
Set up a deployment pipeline that:
- Builds Docker images
- Deploys to Kubernetes
- Performs rolling updates
- Implements health checks

---

## Useful Commands Reference

```bash
# Cluster Management
kubectl cluster-info
kubectl get nodes
kubectl get componentstatuses

# Working with Resources
kubectl get <resource>
kubectl describe <resource> <name>
kubectl delete <resource> <name>
kubectl apply -f <file.yaml>

# Debugging
kubectl logs <pod-name>
kubectl exec -it <pod-name> -- /bin/bash
kubectl port-forward <pod-name> 8080:80

# Context and Configuration
kubectl config view
kubectl config use-context <context-name>
kubectl config set-context --current --namespace=<namespace>
```

---

## Learning Resources

1. **Official Kubernetes Documentation**: https://kubernetes.io/docs/
2. **Kubernetes by Example**: https://kubernetesbyexample.com/
3. **Play with Kubernetes**: https://labs.play-with-k8s.com/
4. **CNCF Kubernetes Certification**: Consider pursuing CKA/CKAD

## Tips for Success

1. **Practice Daily**: Spend at least 30 minutes each day with hands-on exercises
2. **Break Things**: Don't be afraid to experiment and break things in your Codespace
3. **Use Version Control**: Keep all your YAML files in Git
4. **Document Your Learning**: Create notes and document issues you encounter
5. **Join Communities**: Engage with Kubernetes communities on Slack, Reddit, or Discord

## Next Steps

After completing this path:
- Learn Helm for package management
- Explore service meshes (Istio, Linkerd)
- Study GitOps with ArgoCD or Flux
- Learn about observability tools (Prometheus, Grafana)
- Explore serverless with Knative