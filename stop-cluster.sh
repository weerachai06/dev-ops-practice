#!/bin/bash

echo "🛑 Stopping Kubernetes cluster..."

# Stop k3d cluster
if k3d cluster list | grep -q "k3s-default"; then
    echo "⏹️  Stopping k3d cluster 'k3s-default'..."
    k3d cluster stop k3s-default
    echo "✅ Cluster stopped successfully"
else
    echo "ℹ️  No cluster named 'k3s-default' found"
fi

echo ""
echo "💡 To start the cluster again, run:"
echo "   ./start-cluster.sh"
echo ""
echo "💡 To delete the cluster completely, run:"
echo "   k3d cluster delete k3s-default"
