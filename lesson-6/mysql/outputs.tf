resource "null_resource" "wait_for_mysql_instance" {
  provisioner "local-exec" {
    command = <<EOT
    while [ -z "$(aws ec2 describe-instances --filters "Name=tag:aws:autoscaling:groupName,Values=mysql" "Name=instance-state-name,Values=running" --query "Reservations[].Instances[].PublicIpAddress" --output text)" ]; do
      echo "Waiting for MySQL instance to become available..."
      sleep 10
    done
    EOT
  }
  depends_on = [aws_autoscaling_group.mysql]
}

# Fetch the public IP of the MySQL instance once it's available
data "aws_instance" "mysql_instance" {
  filter {
    name   = "tag:aws:autoscaling:groupName"
    values = ["mysql"]
  }

  filter {
    name   = "instance-state-name"
    values = ["running"]
  }

  depends_on = [null_resource.wait_for_mysql_instance]
}

output "mysql_instance_public_ip" {
  description = "The public IP of the MySQL instance"
  value       = data.aws_instance.mysql_instance.public_ip
}
