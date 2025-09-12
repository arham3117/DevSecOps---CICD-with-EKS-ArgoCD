#!/bin/bash

# ArgoCD CLI Installation Script
set -e

echo "🚀 Installing ArgoCD CLI..."

# Download ArgoCD CLI
echo "⬇️  Downloading ArgoCD CLI (latest version)..."
sudo curl --silent --location -o /usr/local/bin/argocd \
  https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64

# Make it executable
echo "🔧 Making ArgoCD CLI executable..."
sudo chmod +x /usr/local/bin/argocd

# Verify installation
echo "✅ Verifying installation..."
if command -v argocd &> /dev/null; then
    echo "🎉 ArgoCD CLI installed successfully!"
    echo "📌 Version:"
    argocd version --client
else
    echo "❌ Installation failed"
    exit 1
fi

echo ""
echo "📚 Next steps:"
echo "1. Port-forward ArgoCD server: kubectl port-forward svc/argocd-server -n argocd 8080:443"
echo "2. Login: argocd login localhost:8080"
echo "3. Get initial password: kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d"