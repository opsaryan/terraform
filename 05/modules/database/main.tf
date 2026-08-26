resource "aws_db_subnet_group" "db_subnets" {
    name = "${var.project_name}-${var.environment}-db-subnets"
    subnet_ids = var.subnet_ids
    tags = {
      Name = "${var.project_name}-${var.environment}-db-subnets"
    }
}

resource "aws_security_group" "sg_database" {
    name = "${var.project_name}-${var.environment}-database"
    vpc_id = var.vpc_id
    tags = {
      Name = "${var.project_name}-${var.environment}-database-sg"
    }
}

resource "aws_security_group_rule" "sg_database_mysql" {
    security_group_id = aws_security_group.sg_database.id
    type = "ingress"
    protocol = "tcp"
    to_port = 3306
    from_port = 3306
    source_security_group_id = var.server_security_group_id
}

resource "aws_db_instance" "database" {
    identifier = "${var.project_name}-${var.environment}-db"
    engine = "mysql"
    engine_version = "8.0"
    instance_class = var.instance_class
    allocated_storage = var.allocated_storage
    storage_encrypted = true
    db_name = var.db_name
    username = var.db_username
    password = var.db_password
    db_subnet_group_name = aws_db_subnet_group.db_subnets.name
    vpc_security_group_ids = [ aws_security_group.sg_database.id ]
    publicly_accessible = false
    skip_final_snapshot = true
    tags = {
      Name = "${var.project_name}-${var.environment}-db"
    }
}
