# Variable definitions for configurable infrastructure parameters
# These allow the same code to be used across different environments

# AWS region where all resources will be deployed
# Changing this will deploy the entire infrastructure to a different region
variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-2"
}

# EC2 instance type for the web server
# t2.large provides 2 vCPUs and 8GB RAM - suitable for development/staging
# For production, consider t3.large or larger instances
variable "instance_type" {
  description = "The type of EC2 instance to use"
  type        = string
  default     = "t2.large"
}

# AMI ID variable (currently not used in main.tf as dynamic lookup is preferred)
# This could be used as a fallback or for specific AMI requirements
variable "ami_id" {
  description = "The AMI ID for the EC2 instance"
  type        = string
  default     = "ami-0cfde0ea8edd312d4" # Ubuntu Server 20.04 LTS in us-east-2
}

# Environment identifier for resource naming and tagging
# Helps distinguish between dev, staging, and production resources
variable "my_environment" {
  description = "The environment for the deployment (e.g., dev, prod)"
  type        = string
  default     = "dev"
}