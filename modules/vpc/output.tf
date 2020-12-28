output "vpc_id" {
  value = aws_vpc.main.id
}

output "security_group_instance_id" {
  value = aws_security_group.sg_instance.id
}

output "security_group_lb_id" {
  value = aws_security_group.sg_lb.id
}

output "subnet_public_id_list" {
  value = aws_subnet.public.*.id
}

output "subnet_private_id_list" {
  value = aws_subnet.private.*.id
}
