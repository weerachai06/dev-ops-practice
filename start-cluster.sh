#!/bin/bash

echo "🚀 Starting Kubernetes cluster with k3d..."

# Check if cluster already exists
if k3d cluster list | grep -q "dev-cluster"; then
    echo "✅ Cluster 'dev-cluster' already exists"
    k3d cluster start dev-cluster
else
    echo "📦 Creating new k3d cluster..."
    k3d cluster create dev-cluster --port "8080:80@loadbalancer"
fi

# Set kubectl context
echo "🔧 Setting kubectl context..."
kubectl config use-context k3d-dev-cluster

# Wait for cluster to be ready
echo "⏳ Waiting for cluster to be ready..."
kubectl wait --for=condition=Ready nodes --all --timeout=60s

# Show cluster info
echo "🎉 Cluster is ready!"
kubectl cluster-info
echo ""
echo "📋 Current cluster status:"
kubectl get nodes
echo ""
echo "🚀 You can now use kubectl commands!"
echo "   kubectl get pods -A"
echo "   kubectl apply -f day1-kube/"
echo "   kubectl get all"
