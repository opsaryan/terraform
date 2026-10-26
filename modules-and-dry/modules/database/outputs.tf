output "endpoint" {
  value = aws_db_instance.database.endpoint
}

output "db_name" {
  value = aws_db_instance.database.db_name
}

output "security_group_id" {
  value = aws_security_group.sg_database.id
}
