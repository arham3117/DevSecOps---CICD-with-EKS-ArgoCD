#!/bin/bash

# eksctl Installation Script for Ubuntu EC2
# This script installs eksctl (Amazon EKS cluster management tool)

set -e  # Exit on any error

echo "🚀 Installing eksctl on Ubuntu EC2..."

# Set architecture - adjust if needed for ARM instances
ARCH=amd64
PLATFORM=$(uname -s)_$ARCH

echo "📋 Detected platform: $PLATFORM"

# Create temporary directory if it doesn't exist
mkdir -p /tmp

echo "⬇️  Downloading eksctl..."
curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"

echo "🔍 Verifying checksum..."
if curl -sL "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_checksums.txt" | grep $PLATFORM | sha256sum --check; then
    echo "✅ Checksum verification passed"
else
    echo "❌ Checksum verification failed"
    exit 1
fi

echo "📦 Extracting eksctl..."
tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz

echo "🔧 Installing eksctl to /usr/local/bin..."
sudo install -m 0755 /tmp/eksctl /usr/local/bin && rm /tmp/eksctl

echo "🎉 Installation complete!"

# Verify installation
echo "✅ Verifying installation..."
if command -v eksctl &> /dev/null; then
    echo "📌 eksctl version:"
    eksctl version
    echo ""
    echo "🌟 eksctl installed successfully!"
    echo "💡 You can now use 'eksctl' command to manage EKS clusters"
else
    echo "❌ Installation failed - eksctl command not found"
    exit 1
fi

echo ""
echo "📚 Next steps:"
echo "1. Configure AWS credentials: aws configure"
echo "2. Create EKS cluster: eksctl create cluster --name my-cluster --region us-west-2"
echo "3. Get help: eksctl --help"