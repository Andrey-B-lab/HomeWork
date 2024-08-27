provider "aws" {
  region = "eu-west-1" 
}

# Data source to get the default security group
data "aws_security_group" "default" {
  filter {
    name   = "group-name"
    values = ["default"]
  }

  vpc_id = aws_vpc.default.id
}

# Resource to create a VPC
resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"
}

# Resource to create a subnet
resource "aws_subnet" "default" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-west-1a"
}

# Ingress rule for port 8080 on the default security group
resource "aws_security_group_rule" "allow_http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = data.aws_security_group.default.id
}

# Launch template using the default security group
resource "aws_launch_template" "bookstock" {
  name_prefix   = "bookstock"
  image_id      = "ami-0034529272b0a8509"  # Amazon Linux 2 AMI
  instance_type = "t2.micro"

  vpc_security_group_ids = [data.aws_security_group.default.id]

  user_data = base64encode(<<-EOF
  #!/usr/bin/bash
  yum install docker -y
  systemctl enable docker
  systemctl start docker 
  docker network create bookstack_nw
  docker run -d --net bookstack_nw  \
  -e MYSQL_ROOT_PASSWORD=secret \
  -e MYSQL_DATABASE=bookstack \
  -e MYSQL_USER=bookstack \
  -e MYSQL_PASSWORD=secret \
  --name="bookstack_db" \
  mysql:5.7.21
  docker run -d --net bookstack_nw  \
  -e DB_HOST=bookstack_db:3306 \
  -e DB_DATABASE=bookstack \
  -e DB_USERNAME=bookstack \
  -e DB_PASSWORD=secret \
  -p 8080:80 \
  solidnerd/bookstack:0.27.5
  EOF
  )
}

# Auto Scaling group using the launch template
resource "aws_autoscaling_group" "bookstock" {
  desired_capacity     = 1
  max_size             = 1
  min_size             = 1
  vpc_zone_identifier  = [aws_subnet.default.id]

  launch_template {
    id      = aws_launch_template.bookstock.id
    version = "$Latest"
  }
}

# Outputs for reference
output "security_group_id" {
  value = data.aws_security_group.default.id
}

output "launch_template_id" {
  value = aws_launch_template.bookstock.id
}

output "autoscaling_group_name" {
  value = aws_autoscaling_group.bookstock.name
}
