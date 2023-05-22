output "app_instance_id" {
  description = "ID of the EC2 instance"
  value = aws_instance.app_instance.id
}

output "app_instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.app_instance.public_ip
}
