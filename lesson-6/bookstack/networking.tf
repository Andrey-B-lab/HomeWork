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
