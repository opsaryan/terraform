variable "region" {
  description = "Specifies the region for resources"
  default     = "ap-south-1"
  type        = string
}

variable "project_name" {
  description = "Specifies the name prefix for all the resources"
  default     = "modular-app"
  type        = string
}

variable "vpc_cidr" {
  description = "Specifies the cidr block for the vpc"
  default     = "192.168.0.0/16"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "Specifies the cidr blocks for the public subnets"
  default     = ["192.168.0.0/20", "192.168.16.0/20"]
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "Specifies the cidr blocks for the private subnets"
  default     = ["192.168.32.0/20", "192.168.48.0/20"]
  type        = list(string)
}

variable "availability_zones" {
  description = "Specifies the availability zones for the subnets"
  default     = ["ap-south-1a", "ap-south-1b"]
  type        = list(string)
}

variable "server_count" {
  description = "Specifies how many servers to create"
  default     = 2
  type        = number
}

variable "server_ami" {
  description = "Specifies the AMI for the servers"
  default     = "ami-006f82a1d5a27da54"
  type        = string
}

variable "server_instance_type" {
  description = "Specifies the instance type for the servers"
  default     = "t3.micro"
  type        = string
}

variable "db_name" {
  description = "Specifies the name of the initial database"
  default     = "appdb"
  type        = string
}

variable "db_username" {
  description = "Specifies the master username of the database"
  default     = "appadmin"
  type        = string
}

variable "db_password" {
  description = "Specifies the master password of the database"
  type        = string
  sensitive   = true
}
