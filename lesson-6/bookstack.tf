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
