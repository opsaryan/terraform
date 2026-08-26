output "instance_ids" {
  value = aws_instance.server[*].id
}

output "public_ips" {
  value = aws_instance.server[*].public_ip
}

output "security_group_id" {
  value = aws_security_group.sg_servers.id
}
