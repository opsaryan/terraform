output "state_bucket_name" {
    value = aws_s3_bucket.tf_state.id
}

output "state_table_name" {
    value = aws_dynamodb_table.tf_state_lock.id
}

output "zone_id" {
    value = aws_route53_zone.primary.zone_id
}

output "name_servers" {
    value = aws_route53_zone.primary.name_servers
}
