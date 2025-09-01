#!/bin/bash

# eksctl Installation Script for macOS via Homebrew
# Simple and straightforward installation

set -e  # Exit on any error

echo "🚀 Installing eksctl via Homebrew..."

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "❌ Homebrew not found. Please install Homebrew first:"
    echo "   /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    exit 1
fi

# Install eksctl
echo "📦 Tapping weaveworks repository..."
brew tap weaveworks/tap

echo "⬇️  Installing eksctl..."
brew install weaveworks/tap/eksctl

# Verify installation
echo "🔍 Verifying installation..."
if command -v eksctl &> /dev/null; then
    echo "✅ eksctl installed successfully!"
    echo "📋 Version:"
    eksctl version
    echo ""
    echo "🎯 Ready to use eksctl!"
else
    echo "❌ Installation failed"
    exit 1
fi

echo ""
echo "📚 Next steps:"
echo "   1. Configure AWS: aws configure"
echo "   2. Create cluster: eksctl create cluster --name my-cluster --region us-west-2"