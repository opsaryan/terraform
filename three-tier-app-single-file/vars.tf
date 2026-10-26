variable "region" {
    description = "Specifies the region for resources"
    default = "ap-south-1"
    type = string
}

variable "app_ami" {
    description = "Specifies the AMI for the application behind lb"
    default = "ami-006f82a1d5a27da54"
    type = string
}

variable "app_domain" {
    description = "Specifies the domain for the route53"
    type = string
}

variable "app_instance_type" {
    description = "Specifies the instance type"
    type = string
    default = "t3.micro"
}