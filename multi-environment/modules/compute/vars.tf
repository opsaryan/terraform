variable "project_name" {
    description = "Specifies the name of the project"
    type = string
}

variable "environment" {
    description = "Specifies the environment the servers belong to"
    type = string
}

variable "vpc_id" {
    description = "Specifies the vpc the servers are created in"
    type = string
}

variable "subnet_ids" {
    description = "Specifies the subnets the servers are placed in"
    type = list(string)
}

variable "lb_security_group_id" {
    description = "Specifies the security group of the load balancer that reaches the servers"
    type = string
}

variable "server_count" {
    description = "Specifies how many servers to create"
    type = number
    default = 2
}

variable "instance_type" {
    description = "Specifies the instance type for the servers"
    type = string
    default = "t3.micro"
}
