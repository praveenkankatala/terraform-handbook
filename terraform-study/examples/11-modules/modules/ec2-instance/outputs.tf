output "instance_id" {
  description = "ID of the created instance"
  value       = aws_instance.this.id
}

output "private_ip" {
  description = "Private IP of the created instance"
  value       = aws_instance.this.private_ip
}
