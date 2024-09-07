output "vpc_id" {
  value = aws_vpc.main_vpc.id
}

output "security_group_id" {
  value = aws_security_group.dokuwiki_sg.id
}

output "subnet_ids" {
  value = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id]
}
