variable "region" {
    description = "Specifies the region for the global resources"
    default = "ap-south-1"
    type = string
}

variable "state_bucket_name" {
    description = "Specifies the bucket that stores the terraform state of every environment"
    default = "tf-state-6547-05"
    type = string
}

variable "state_table_name" {
    description = "Specifies the dynamodb table used for state locking"
    default = "tf-state-05"
    type = string
}

variable "domain_name" {
    description = "Specifies the domain shared by every environment"
    default = "example.com"
    type = string
}
