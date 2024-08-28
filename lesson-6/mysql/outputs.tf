output "mysql_instance_public_ip" {
  description = "The public IP of the MySQL instance"
  value       = aws_instance.mysql_instance.public_ip
}
