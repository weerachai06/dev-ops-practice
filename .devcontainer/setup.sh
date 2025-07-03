#!/bin/bash

echo "🚀 Setting up Kubernetes development environment..."

# Detect OS and set package manager
if [ -f /etc/alpine-release ]; then
    echo "📦 Detected Alpine Linux - installing packages with apk..."
    sudo apk update
    sudo apk add --no-cache curl bash
    INSTALL_CMD="apk add --no-cache"
elif [ -f /etc/debian_version ]; then
    echo "📦 Detected Debian/Ubuntu - installing packages with apt..."
    sudo apt-get update
    INSTALL_CMD="apt-get install -y"
else
    echo "⚠️  Unknown OS - proceeding with generic setup..."
fi

# Install kind (Kubernetes in Docker) if not present
if ! command -v kind &> /dev/null; then
    echo "📦 Installing kind..."
    sudo curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.23.0/kind-linux-amd64
    sudo chmod +x ./kind
    sudo mv ./kind /usr/local/bin/kind
else
    echo "✅ kind already installed"
fi

# Install kubectl if not present
if ! command -v kubectl &> /dev/null; then
    echo "📦 Installing kubectl..."
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    rm kubectl
else
    echo "✅ kubectl already installed"
fi

# Fix Docker permissions
echo "🔧 Fixing Docker permissions..."
if command -v docker &> /dev/null; then
    sudo chmod 666 /var/run/docker.sock || true
    echo "✅ Docker permissions fixed"
else
    echo "⚠️  Docker not found - skipping permission fix"
fi

# Create kind cluster if it doesn't exist
if ! kind get clusters | grep -q "my-cluster"; then
    echo "🔧 Creating kind cluster..."
    kind create cluster --name my-cluster
    echo "⚙️  Setting up kubectl context..."
    kind export kubeconfig --name my-cluster
else
    echo "✅ kind cluster 'my-cluster' already exists"
    echo "⚙️  Setting up kubectl context..."
    kind export kubeconfig --name my-cluster
fi

# Verify installations
echo "✅ Verifying installations..."
echo "Docker version:"
docker --version || echo "Docker not available"

echo "kubectl version:"
kubectl version --client || echo "kubectl not available"

echo "kind version:"
kind version || echo "kind not available"

echo "Cluster info:"
kubectl cluster-info || echo "No cluster available"

# Set proper permissions
echo "🔒 Setting proper permissions..."
sudo chown -R vscode:vscode /workspaces/dev-ops-practice
sudo chmod +x /workspaces/dev-ops-practice/.devcontainer/*.sh

echo "🎉 Setup completed!"
echo ""
echo "Quick start commands:"
echo "  kind create cluster    # Create Kubernetes cluster"
echo "  kubectl get nodes     # Verify cluster"
echo "  kubectl get all       # List all resources"
echo ""
