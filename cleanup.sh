#!/bin/bash

echo "🧹 Cleaning up development environment..."

# Stop and delete k3d cluster
if k3d cluster list | grep -q "k3s-default"; then
    echo "🗑️  Deleting k3d cluster 'k3s-default'..."
    k3d cluster delete k3s-default
    echo "✅ Cluster deleted successfully"
else
    echo "ℹ️  No cluster named 'k3s-default' found"
fi

# Clean up kubectl config
echo "🔧 Cleaning up kubectl config..."
kubectl config delete-context k3d-k3s-default 2>/dev/null || true
kubectl config delete-cluster k3d-k3s-default 2>/dev/null || true
kubectl config delete-user admin@k3d-k3s-default 2>/dev/null || true

# Clean up temporary files
echo "🧹 Cleaning up temporary files..."
sudo rm -rf /tmp/k3d-*
sudo rm -rf /tmp/docker*
sudo rm -rf /tmp/*.log

# Clean up unused Docker images and containers
echo "🐳 Cleaning up Docker resources..."
docker system prune -f 2>/dev/null || true

echo ""
echo "✅ Cleanup completed!"
echo ""
echo "💡 To start fresh, run:"
echo "   ./start-cluster.sh"
