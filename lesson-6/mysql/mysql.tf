# MySQL Launch Template
resource "aws_launch_template" "mysql" {
  name_prefix   = "mysql"
  image_id      = "ami-0034529272b0a8509"
  instance_type = "t2.micro"

  vpc_security_group_ids = [data.aws_security_group.default.id]

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "MySQL-Instance"
    }
  }

  user_data = base64encode(<<-EOF
  #!/usr/bin/bash
yum install docker -y
systemctl enable docker
systemctl start docker 
docker run -d  \
  -e MYSQL_ROOT_PASSWORD=${var.mysql_root_password} \
  -e MYSQL_DATABASE=${var.mysql_database} \
  -e MYSQL_USER=${var.mysql_user} \
  -e MYSQL_PASSWORD=${var.mysql_password} \
-p 3306:3306
 mysql:5.7.21
  EOF
  )
}
