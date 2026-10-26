output "vpc_id" {
  value = module.network.vpc_id
}

output "server_ids" {
  value = module.servers.instance_ids
}

output "server_public_ips" {
  value = module.servers.public_ips
}

output "database_endpoint" {
  value = module.database.endpoint
}
