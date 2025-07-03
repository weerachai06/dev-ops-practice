#!/bin/bash

echo "🚀 Starting Kubernetes cluster with k3d..."

# Check if cluster already exists
if k3d cluster list | grep -q "k3s-default"; then
    echo "✅ Cluster 'k3s-default' already exists"
    k3d cluster start k3s-default
else
    echo "📦 Creating new k3d cluster from config..."
    k3d cluster create --config .devcontainer/k3d.yml
fi

# Set kubectl context (k3d config will handle this automatically)
echo "🔧 Setting kubectl context..."
kubectl config use-context k3d-k3s-default

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
