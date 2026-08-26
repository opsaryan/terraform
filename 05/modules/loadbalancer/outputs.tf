output "dns_name" {
    value = aws_lb.load_balancer.dns_name
}

output "zone_id" {
    value = aws_lb.load_balancer.zone_id
}

output "security_group_id" {
    value = aws_security_group.sg_lb.id
}
