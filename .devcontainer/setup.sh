#!/bin/bash

echo "🚀 Setting up Kubernetes development environment..."

# Update package list
# sudo apt-get update

# Install kind (Kubernetes in Docker)
echo "📦 Installing kind..."
sudo curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.23.0/kind-linux-amd64
sudo chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind


echo "🔧 Fixing Docker permissions..."
# Ensure Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker not found. Please install Docker first."
    exit 1
fi

sudo chmod 666 /var/run/docker.sock

# Checking cluster status, and creating a cluster if none exists
if ! kind get clusters &> /dev/null; then
    echo "🌐 No kind clusters found. Creating a new cluster..."
    kind create cluster --name devops-practice --config /workspaces/dev-ops-practice/kind-config.yaml
else
    echo "🌐 Kind cluster already exists. Skipping creation."
fi

# Verify installations
echo "✅ Verifying installations..."
echo "Docker version:"
docker --version

echo "kubectl version:"
kubectl version --client

echo "kind version:"
kind version

# Set up kubectl auto-completion
echo "⚙️ Setting up kubectl auto-completion..."
# echo 'source <(kubectl completion bash)' >> ~/.bashrc
# echo 'alias k=kubectl' >> ~/.bashrc
# echo 'complete -o default -F __start_kubectl k' >> ~/.bashrc

# Set up useful aliases
echo "🔗 Setting up aliases..."
# cat << 'EOF' >> ~/.bashrc

# # Kubernetes aliases
# alias k=kubectl
# alias kgp="kubectl get pods"
# alias kgs="kubectl get services" 
# alias kgd="kubectl get deployments"
# alias kga="kubectl get all"
# alias kdp="kubectl describe pod"
# alias kds="kubectl describe service"
# alias kdd="kubectl describe deployment"
# alias kl="kubectl logs"
# alias kpf="kubectl port-forward"
# alias kex="kubectl exec -it"

# # Kind aliases
# alias kc-create="kind create cluster"
# alias kc-delete="kind delete cluster"
# alias kc-list="kind get clusters"

# # Docker aliases
# alias dps="docker ps"
# alias di="docker images"
# alias dc="docker-compose"
# EOF

# Create workspace directories
echo "📁 Creating workspace structure..."
# mkdir -p /workspaces/dev-ops-practice/day2-advanced
# mkdir -p /workspaces/dev-ops-practice/day3-networking
# mkdir -p /workspaces/dev-ops-practice/day4-storage
# mkdir -p /workspaces/dev-ops-practice/examples

# Set proper permissions
sudo chown -R vscode:vscode /workspaces/dev-ops-practice

# echo "🎉 Setup completed! Restart terminal or run 'source ~/.bashrc' to use aliases."
# echo ""
# echo "Quick start commands:"
# echo "  kind create cluster    # Create Kubernetes cluster"
# echo "  kubectl get nodes     # Verify cluster"
# echo "  k get all            # List all resources (using alias)"
# echo ""
