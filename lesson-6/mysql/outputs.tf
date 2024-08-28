# Ensure the MySQL instance has been fully created and is running
data "aws_instance" "mysql_instance" {
  filter {
    name   = "tag:Name"
    values = ["MySQL-Instance"]
  }

  filter {
    name   = "instance-state-name"
    values = ["running"]
  }

  # Ensure the data source waits for the instance to be available
  depends_on = [aws_autoscaling_group.mysql]
}

# Output the public IP address of the MySQL instance
output "mysql_instance_public_ip" {
  description = "The public IP of the MySQL instance"
  value       = data.aws_instance.mysql_instance.public_ip
}
