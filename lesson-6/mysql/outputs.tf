resource "null_resource" "wait_for_mysql_instance" {
  provisioner "local-exec" {
    command = <<EOT
    echo "Waiting for the MySQL instance to become available..."
    while [ -z "$(aws ec2 describe-instances --filters "Name=tag:Name,Values=MySQL-Instance" "Name=instance-state-name,Values=running" --query "Reservations[].Instances[].PublicIpAddress" --output text)" ]; do
      echo "MySQL instance is not ready yet, waiting..."
      sleep 10
    done
    echo "MySQL instance is now available!"
    EOT
  }
  depends_on = [aws_autoscaling_group.mysql]
}

# Fetch the public IP of the MySQL instance once it's available
data "aws_instance" "mysql_instance" {
  filter {
    name   = "tag:Name"
    values = ["MySQL-Instance"]
  }

  filter {
    name   = "instance-state-name"
    values = ["running"]
  }

  depends_on = [null_resource.wait_for_mysql_instance]
}

# Output the public IP address of the MySQL instance
output "mysql_instance_public_ip" {
  description = "The public IP of the MySQL instance"
  value       = data.aws_instance.mysql_instance.public_ip
}
