# Data source to fetch the most recent Ubuntu AMI from Canonical
# This ensures we always use the latest Ubuntu image available
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical's AWS account ID

  # Filter to only include AMIs that are available for use
  filter {
    name = "state"
    values = ["available"]
  }

  # Filter to get Ubuntu images with HVM virtualization and SSD storage for amd64 architecture
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/*amd64*"]
  }
}

# AWS key pair resource for SSH access to EC2 instances
# The public key is read from a local file
resource "aws_key_pair" "deployer_key" {
    key_name   = "arh-bankapp-key"
    public_key = file("arh-bankapp-key.pub")
}

# Use the default VPC in the region
# This is a simple setup - in production, you might want to create a custom VPC
resource "aws_default_vpc" "default" {}

# Security group that allows SSH, HTTP, and HTTPS traffic
# This enables remote access and web traffic to the EC2 instance
resource "aws_security_group" "allow_ssh_http" {
  name        = "allow_ssh_http"
  description = "Allow SSH and HTTP inbound traffic"
  vpc_id      = aws_default_vpc.default.id

  # Allow SSH access from anywhere (port 22)
  # Note: In production, consider restricting this to specific IP ranges
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # Allow HTTP traffic (port 80) for web applications
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # Allow HTTPS traffic (port 443) for secure web applications
  ingress {
    description = "HTTPS"
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # Allow all outbound traffic
  # This enables the instance to download packages, updates, etc.
  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "bankapp-security-group"
  }
} 

# Main EC2 instance for hosting the web server/application
# Uses the Ubuntu AMI and configures storage and networking
resource "aws_instance" "bank-web-server" {
    # Use the Ubuntu AMI found by the data source
    ami           = data.aws_ami.ubuntu.id
    
    # Instance type is configurable via variable (default: t2.large)
    instance_type = var.instance_type
    
    # SSH key pair for remote access
    key_name      = aws_key_pair.deployer_key.key_name
    
    # Attach the security group that allows SSH, HTTP, and HTTPS
    security_groups = [aws_security_group.allow_ssh_http.name]
    
    # Tags for resource identification and management
    tags = {
        Name        = "bankapp-web-server-${var.my_environment}"
        Environment = var.my_environment
    }
    
    # Configure root EBS volume
    # 30GB gp3 storage should be sufficient for most applications
    root_block_device {
        volume_size = 30                    # Size in GB
        volume_type = "gp3"                 # General Purpose SSD v3 (cost-effective)
        #delete_on_termination = true       # Clean up storage when instance is terminated
    }
}