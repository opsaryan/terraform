variable "project_name" {
    description = "Specifies the name of the project"
    type = string
}

variable "environment" {
    description = "Specifies the environment the network belongs to"
    type = string
}

variable "vpc_cidr" {
    description = "Specifies the cidr block for the vpc"
    type = string
}

variable "public_subnet_cidrs" {
    description = "Specifies the cidr blocks for the public subnets"
    type = list(string)
}

variable "private_subnet_cidrs" {
    description = "Specifies the cidr blocks for the private subnets"
    type = list(string)
}
