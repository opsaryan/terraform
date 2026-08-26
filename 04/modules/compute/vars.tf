variable "project_name" {
  description = "Specifies the name prefix for the servers"
  type        = string
}

variable "vpc_id" {
  description = "Specifies the vpc the servers are created in"
  type        = string
}

variable "subnet_ids" {
  description = "Specifies the subnets the servers are placed in"
  type        = list(string)
}

variable "server_count" {
  description = "Specifies how many servers to create"
  type        = number
  default     = 2
}

variable "ami" {
  description = "Specifies the AMI for the servers"
  type        = string
}

variable "instance_type" {
  description = "Specifies the instance type"
  type        = string
  default     = "t3.micro"
}
