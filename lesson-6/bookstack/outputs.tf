output "security_group_id" {
  value = data.aws_security_group.default.id
}

output "launch_template_id" {
  value = aws_launch_template.bookstock.id
}

output "autoscaling_group_name" {
  value = aws_autoscaling_group.bookstock.name
}
