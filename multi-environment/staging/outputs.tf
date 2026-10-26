output "vpc_id" {
    value = module.network.vpc_id
}

output "server_ids" {
    value = module.servers.instance_ids
}

output "lb_dns_name" {
    value = module.loadbalancer.dns_name
}

output "app_url" {
    value = "http://${aws_route53_record.app.name}"
}

output "database_endpoint" {
    value = module.database.endpoint
}
