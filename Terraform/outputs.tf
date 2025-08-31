# Output values to display important information after deployment
# These values are useful for connecting to and managing the created resources

# Public IP address of the EC2 instance
# Use this IP to SSH into the server or access web applications
output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.bank-web-server.public_ip
}

# Public DNS name of the EC2 instance
# Alternative way to access the server using AWS-provided DNS
output "instance_public_dns" {
  description = "Public DNS name of the EC2 instance"
  value       = aws_instance.bank-web-server.public_dns
}

# Instance ID for AWS console and CLI operations
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.bank-web-server.id
}

# Security group ID for reference in other resources or modifications
output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.allow_ssh_http.id
}

# SSH connection command for easy access
output "ssh_connection_command" {
  description = "Command to SSH into the instance"
  value       = "ssh -i arh-bankapp-key ubuntu@${aws_instance.bank-web-server.public_ip}"
}