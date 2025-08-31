# Terraform configuration block
# Defines required providers and their versions for consistency and compatibility
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"     # Official AWS provider from HashiCorp
      version = "6.11.0"           # Pin to specific version for reproducible deployments
    }
  }
}

# AWS Provider configuration
# Configures authentication and default region for AWS resources
provider "aws" {
  # AWS region is configurable via variable (default: us-east-2)
  region = var.aws_region
}