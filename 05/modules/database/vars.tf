variable "project_name" {
    description = "Specifies the name of the project"
    type = string
}

variable "environment" {
    description = "Specifies the environment the database belongs to"
    type = string
}

variable "vpc_id" {
    description = "Specifies the vpc the database is created in"
    type = string
}

variable "subnet_ids" {
    description = "Specifies the private subnets for the db subnet group"
    type = list(string)
}

variable "server_security_group_id" {
    description = "Specifies the security group that is allowed to reach the database"
    type = string
}

variable "instance_class" {
    description = "Specifies the instance class for the database"
    type = string
    default = "db.t3.micro"
}

variable "allocated_storage" {
    description = "Specifies the storage in GB for the database"
    type = number
    default = 20
}

variable "db_name" {
    description = "Specifies the name of the initial database"
    type = string
}

variable "db_username" {
    description = "Specifies the master username of the database"
    type = string
}

variable "db_password" {
    description = "Specifies the master password of the database"
    type = string
    sensitive = true
}
