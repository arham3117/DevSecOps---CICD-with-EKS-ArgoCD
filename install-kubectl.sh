#!/bin/bash

# kubectl Installation Script for Ubuntu EC2
# This script installs kubectl (Kubernetes command-line tool)

set -e  # Exit on any error

echo "🚀 Installing kubectl on Ubuntu EC2..."

# Get the latest stable version and download kubectl
echo "⬇️  Downloading kubectl (latest stable version)..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

# Download the kubectl checksum file
echo "⬇️  Downloading kubectl checksum..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"

# Verify the kubectl binary against the checksum file
echo "🔍 Verifying kubectl checksum..."
if echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check; then
    echo "✅ Checksum verification passed"
else
    echo "❌ Checksum verification failed"
    rm -f kubectl kubectl.sha256
    exit 1
fi

# Install kubectl
echo "🔧 Installing kubectl to /usr/local/bin..."
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Clean up downloaded files
echo "🧹 Cleaning up temporary files..."
rm -f kubectl kubectl.sha256

echo "🎉 Installation complete!"

# Verify installation
echo "✅ Verifying installation..."
if command -v kubectl &> /dev/null; then
    echo "📌 kubectl version:"
    kubectl version --client
    echo ""
    echo "🌟 kubectl installed successfully!"
    echo "💡 You can now use 'kubectl' command to manage Kubernetes clusters"
else
    echo "❌ Installation failed - kubectl command not found"
    exit 1
fi

echo ""
echo "📚 Next steps:"
echo "1. Configure your kubeconfig: aws eks update-kubeconfig --region <region> --name <cluster-name>"
echo "2. Test connection: kubectl get nodes"
echo "3. Get help: kubectl --help"
echo "4. Enable bash completion (optional): echo 'source <(kubectl completion bash)' >> ~/.bashrc"