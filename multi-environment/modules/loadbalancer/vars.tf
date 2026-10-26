variable "project_name" {
    description = "Specifies the name of the project"
    type = string
}

variable "environment" {
    description = "Specifies the environment the load balancer belongs to"
    type = string
}

variable "vpc_id" {
    description = "Specifies the vpc the load balancer is created in"
    type = string
}

variable "subnet_ids" {
    description = "Specifies the public subnets for the load balancer"
    type = list(string)
}

variable "instance_ids" {
    description = "Specifies the servers registered behind the load balancer"
    type = list(string)
}
