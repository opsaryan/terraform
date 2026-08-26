variable "region" {
    description = "Specifies the region for the staging environment"
    default = "ap-south-1"
    type = string
}

variable "project_name" {
    description = "Specifies the name of the project"
    default = "webapp"
    type = string
}

variable "environment" {
    description = "Specifies the environment name used in every resource name"
    default = "staging"
    type = string
}

variable "domain_name" {
    description = "Specifies the domain created in the global directory"
    default = "example.com"
    type = string
}

variable "subdomain" {
    description = "Specifies the record that points at the load balancer"
    default = "staging.example.com"
    type = string
}

variable "vpc_cidr" {
    description = "Specifies the cidr block for the vpc"
    default = "10.0.0.0/16"
    type = string
}

variable "public_subnet_cidrs" {
    description = "Specifies the cidr blocks for the public subnets"
    default = ["10.0.0.0/20", "10.0.16.0/20"]
    type = list(string)
}

variable "private_subnet_cidrs" {
    description = "Specifies the cidr blocks for the private subnets"
    default = ["10.0.32.0/20", "10.0.48.0/20"]
    type = list(string)
}

variable "server_count" {
    description = "Specifies how many servers to create"
    default = 2
    type = number
}

variable "server_instance_type" {
    description = "Specifies the instance type for the servers"
    default = "t3.micro"
    type = string
}

variable "db_instance_class" {
    description = "Specifies the instance class for the database"
    default = "db.t3.micro"
    type = string
}

variable "db_allocated_storage" {
    description = "Specifies the storage in GB for the database"
    default = 20
    type = number
}

variable "db_name" {
    description = "Specifies the name of the initial database"
    default = "webappdb"
    type = string
}

variable "db_username" {
    description = "Specifies the master username of the database"
    default = "webappadmin"
    type = string
}

variable "db_password" {
    description = "Specifies the master password of the database"
    type = string
    sensitive = true
}
