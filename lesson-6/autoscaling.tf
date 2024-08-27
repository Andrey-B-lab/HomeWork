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
