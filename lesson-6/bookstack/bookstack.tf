#bookstack instance
resource "aws_launch_template" "bookstock" {
  name_prefix   = "bookstock"
  image_id      = "ami-0034529272b0a8509"
  instance_type = "t2.micro"

  vpc_security_group_ids = [data.aws_security_group.default.id]

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "bookstack-Instance"
    }
  }

  user_data = base64encode(<<-EOF
  #!/usr/bin/bash
yum install docker -y
systemctl enable docker
systemctl start docker 
docker run -d --net bookstack_nw  \
-e DB_HOST=$${terraform output mysql_instance_public_ip}:3306 \
  -e DB_DATABASE=${var.mysql_database} \
  -e DB_USERNAME=${var.mysql_user} \
  -e DB_PASSWORD=${var.mysql_password} \
-p 8080:80 \
 solidnerd/bookstack:0.27.5
  EOF
  )
}
