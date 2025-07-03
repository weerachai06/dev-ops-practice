#!/bin/bash

echo "🛑 Stopping Kubernetes cluster..."

# Stop k3d cluster
if k3d cluster list | grep -q "dev-cluster"; then
    echo "⏹️  Stopping k3d cluster 'dev-cluster'..."
    k3d cluster stop dev-cluster
    echo "✅ Cluster stopped successfully"
else
    echo "ℹ️  No cluster named 'dev-cluster' found"
fi

echo ""
echo "💡 To start the cluster again, run:"
echo "   ./start-cluster.sh"
echo ""
echo "💡 To delete the cluster completely, run:"
echo "   k3d cluster delete dev-cluster"
