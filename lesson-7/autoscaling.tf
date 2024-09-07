# Auto Scaling Group with 1 instance
resource "aws_autoscaling_group" "dokuwiki_asg" {
  vpc_zone_identifier = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id]
  desired_capacity    = 1
  max_size            = 1
  min_size            = 1

  launch_template {
    id      = aws_launch_template.dokuwiki_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "dokuwiki-instance"
    propagate_at_launch = true
  }

  depends_on = [aws_launch_template.dokuwiki_lt]
}
