# Service Deployment Guide - Day 1

## Overview
This guide shows how to deploy a service in your Kubernetes cluster using the YAML files provided.

## Files Included
- `nginx-deployment.yaml` - Deployment configuration
- `nginx-service.yaml` - Service configuration

## Kubernetes Resource Relationship

```
┌─────────────────────────────────────────────────────────────┐
│                        Kubernetes Cluster                   │
│  ┌────────────────────────────────────────────────────────┐ │
│  │                      Namespace                         │ │
│  │  ┌─────────────────┐    ┌─────────────────┐            │ │
│  │  │   Deployment    │    │    Service      │            │ │
│  │  │                 │    │                 │            │ │
│  │  │  ┌───────────┐  │    │  Type: ClusterIP│            │ │
│  │  │  │ ReplicaSet│  │    │  Port: 80       │            │ │
│  │  │  │           │  │    │  Selector:      │            │ │
│  │  │  │ ┌───────┐ │  │    │    app=nginx    │            │ │
│  │  │  │ │ Pod 1 │ │  │◄───┤                 │            │ │
│  │  │  │ └───────┘ │  │    └─────────────────┘            │ │
│  │  │  │ ┌───────┐ │  │                                   │ │
│  │  │  │ │ Pod 2 │ │  │◄───┐                              │ │
│  │  │  │ └───────┘ │  │    │                              │ │
│  │  │  │ ┌───────┐ │  │    │                              │ │
│  │  │  │ │ Pod 3 │ │  │◄───┘                              │ │
│  │  │  │ └───────┘ │  │                                   │ │
│  │  │  └───────────┘  │                                   │ │
│  │  └─────────────────┘                                   │ │
│  └────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘

Flow: Deployment → ReplicaSet → Pods ← Service (routes traffic)
```

## Deployment Steps

### 1. Apply the Deployment
```bash
kubectl apply -f nginx-deployment.yaml
```
**Command Explanation:**
- `kubectl apply`: Creates or updates Kubernetes resources
- `-f`: Specifies file input
- `nginx-deployment.yaml`: YAML file containing deployment configuration

**What happens:**
1. Kubernetes reads the deployment spec
2. Creates a ReplicaSet
3. ReplicaSet creates 3 nginx pods
4. Scheduler assigns pods to nodes

**Expected output:** `deployment.apps/nginx-deployment created`

### 2. Verify Deployment
```bash
kubectl get deployments
```
**Command Explanation:**
- `kubectl get`: Retrieves resource information
- `deployments`: Resource type to list

**Output columns:**
- `NAME`: Deployment name
- `READY`: Ready replicas / Desired replicas
- `UP-TO-DATE`: Number of replicas updated to latest version
- `AVAILABLE`: Number of available replicas
- `AGE`: Time since creation

**Expected output:** Shows nginx-deployment with READY status

### 3. Check Pods
```bash
kubectl get pods -l app=nginx
```
**Command Explanation:**
- `kubectl get pods`: Lists pods
- `-l app=nginx`: Label selector filter (only pods with app=nginx label)

**What it shows:**
- Pod names (auto-generated with random suffix)
- Status (Running, Pending, etc.)
- Restarts count
- Age

**Expected output:** 3 nginx pods running

### 4. Apply the Service
```bash
kubectl apply -f nginx-service.yaml
```
**Command Explanation:**
- Creates a Service resource that provides stable network endpoint
- Service uses label selector to find target pods

**What happens:**
1. Creates ClusterIP (internal cluster IP)
2. Creates endpoints list of pod IPs
3. Sets up iptables rules for load balancing

**Expected output:** `service/nginx-service created`

### 5. Verify Service
```bash
kubectl get services
```
**Command Explanation:**
- Lists all services in current namespace

**Output columns:**
- `NAME`: Service name
- `TYPE`: Service type (ClusterIP, NodePort, LoadBalancer)
- `CLUSTER-IP`: Internal cluster IP address
- `EXTERNAL-IP`: External IP (none for ClusterIP)
- `PORT(S)`: Port mappings
- `AGE`: Time since creation

**Expected output:** Shows nginx-service with ClusterIP

### 6. Test the Service
```bash
# Get service details
kubectl describe service nginx-service
```
**Command Explanation:**
- `kubectl describe`: Shows detailed information about resource
- Displays endpoints, selector, port mappings, events

```bash
# Test connectivity (from within cluster)
kubectl run test-pod --image=busybox -it --rm -- wget -qO- nginx-service
```
**Command Explanation:**
- `kubectl run test-pod`: Creates temporary pod named test-pod
- `--image=busybox`: Uses lightweight Linux image
- `-it`: Interactive terminal mode
- `--rm`: Auto-delete pod when command exits
- `wget -qO- nginx-service`: Downloads content from service and prints to stdout

## Port Forwarding for External Access

### Forward Service Port
```bash
kubectl port-forward service/nginx-service 8080:80
```
**Command Explanation:**
- `kubectl port-forward`: Forwards local port to cluster resource
- `service/nginx-service`: Target service
- `8080:80`: Local port 8080 → Service port 80

**What happens:**
1. Creates secure tunnel from your machine to cluster
2. kubectl proxy handles authentication
3. Traffic forwarded to one of the service endpoints

### Access in Browser
- Open VS Code ports tab
- Click on port 8080 to open in browser
- You should see nginx welcome page

## Monitoring Commands

### Watch Pod Status
```bash
kubectl get pods -l app=nginx -w
```
**Command Explanation:**
- `-w`: Watch mode - continuously updates output
- Shows real-time pod status changes
- Press Ctrl+C to exit watch mode

### View Pod Logs
```bash
kubectl logs -l app=nginx
```
**Command Explanation:**
- `kubectl logs`: Retrieves container logs
- `-l app=nginx`: Gets logs from all pods matching label
- Shows nginx access logs and error logs

**Advanced options:**
```bash
# Follow logs in real-time
kubectl logs -l app=nginx -f

# Get logs from specific pod
kubectl logs nginx-deployment-xxxxx

# Get previous container logs (if crashed)
kubectl logs nginx-deployment-xxxxx --previous
```

### Describe Resources
```bash
# Describe deployment
kubectl describe deployment nginx-deployment
```
**Command Explanation:**
- Shows detailed deployment information:
  - Strategy (RollingUpdate)
  - Conditions (Available, Progressing)
  - ReplicaSet information
  - Events history

```bash
# Describe service
kubectl describe service nginx-service
```
**Shows:**
- Selector labels
- Endpoints (pod IPs)
- Port configurations
- Session affinity settings

## Scaling the Deployment

### Scale Up
```bash
kubectl scale deployment nginx-deployment --replicas=5
```
**Command Explanation:**
- `kubectl scale`: Changes replica count
- `--replicas=5`: Sets desired number of pods to 5

**What happens:**
1. Updates deployment spec
2. ReplicaSet creates 2 additional pods
3. Scheduler assigns new pods to nodes
4. Service automatically includes new pods in load balancing

### Scale Down
```bash
kubectl scale deployment nginx-deployment --replicas=2
```
**What happens:**
1. ReplicaSet terminates 3 pods
2. Kubernetes gracefully shuts down containers
3. Service removes terminated pods from endpoints

### Verify Scaling
```bash
kubectl get pods -l app=nginx
```
**Shows updated pod count and their status**

## Cleanup

### Delete Service and Deployment
```bash
kubectl delete -f nginx-service.yaml
kubectl delete -f nginx-deployment.yaml
```
**Command Explanation:**
- `kubectl delete -f`: Deletes resources defined in file
- Processes files in reverse order of dependencies

**What happens:**
1. Service deletion removes load balancing rules
2. Deployment deletion triggers pod termination
3. ReplicaSet is also deleted
4. All associated resources cleaned up

### Verify Cleanup
```bash
kubectl get deployments
kubectl get services
kubectl get pods
```
**Should show no nginx-related resources**

## Common Issues and Solutions

### Pods Not Starting
```bash
# Check pod events
kubectl describe pods -l app=nginx
```
**Command Explanation:**
- Shows pod events, conditions, and container status
- Look for "Events" section for error messages

**Common issues:**
- Image pull errors
- Resource limits exceeded
- Node capacity issues

```bash
# Check node resources
kubectl top nodes
```
**Shows CPU/memory usage per node (requires metrics-server)**

### Service Not Accessible
```bash
# Check service endpoints
kubectl get endpoints nginx-service
```
**Command Explanation:**
- Shows actual pod IPs that service routes to
- Empty endpoints means no pods match service selector

```bash
# Verify pod labels match service selector
kubectl get pods -l app=nginx --show-labels
```
**Shows all labels on pods to verify selector matching**

### Port Forward Issues
```bash
# Kill existing port forward
pkill -f "kubectl port-forward"
```
**Command Explanation:**
- `pkill -f`: Kills processes matching pattern
- Useful when port-forward gets stuck

```bash
# Start new port forward
kubectl port-forward service/nginx-service 8080:80
```

## Kubernetes Resource Relationships Summary

1. **Deployment** manages **ReplicaSet**
2. **ReplicaSet** manages **Pods**
3. **Service** routes traffic to **Pods** (via label selector)
4. **Pods** contain one or more **Containers**
5. **Containers** run your application code

## Command Categories

### Creation Commands
- `kubectl apply -f <file>` - Create/update resources
- `kubectl create deployment <name> --image=<image>` - Quick deployment

### Viewing Commands
- `kubectl get <resource>` - List resources
- `kubectl describe <resource> <name>` - Detailed info
- `kubectl logs <pod>` - Container logs

### Modification Commands
- `kubectl scale deployment <name> --replicas=<count>` - Scale pods
- `kubectl edit <resource> <name>` - Edit resource

### Debugging Commands
- `kubectl exec -it <pod> -- <command>` - Execute in container
- `kubectl port-forward <resource> <local-port>:<remote-port>` - Port forwarding

### Cleanup Commands
- `kubectl delete <resource> <name>` - Delete specific resource
- `kubectl delete -f <file>` - Delete from file

## Next Steps
- Experiment with different service types (NodePort, LoadBalancer)
- Try different deployment strategies (rolling updates)
- Explore ConfigMaps and Secrets in Day 2
- Learn about persistent volumes and storage classes