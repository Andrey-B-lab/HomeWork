# Data source to get the latest Amazon Linux AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Launch Template for EC2 instance
resource "aws_launch_template" "dokuwiki_lt" {
  name = "dokuwiki-lt"

  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"

  user_data = base64encode(<<-EOF
    #!/usr/bin/bash
    yum install docker -y
    systemctl enable docker
    systemctl start docker 
    docker run -d -p 80:80 --name dokuwiki bitnami/dokuwiki:latest
  EOF
  )

  # Use security group IDs instead of names
  vpc_security_group_ids = [aws_security_group.dokuwiki_sg.id]
}


