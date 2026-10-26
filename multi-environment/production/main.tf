terraform {
  backend "s3" {
    bucket = "tf-state-6547-05"
    key = "production/terraform.tfstate"
    dynamodb_table = "tf-state-05"
    region = "ap-south-1"
    encrypt = true
  }
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.region
}

data "aws_route53_zone" "primary" {
    name = var.domain_name
}

module "network" {
    source = "../modules/network"

    project_name = var.project_name
    environment = var.environment
    vpc_cidr = var.vpc_cidr
    public_subnet_cidrs = var.public_subnet_cidrs
    private_subnet_cidrs = var.private_subnet_cidrs
}

module "loadbalancer" {
    source = "../modules/loadbalancer"

    project_name = var.project_name
    environment = var.environment
    vpc_id = module.network.vpc_id
    subnet_ids = module.network.public_subnet_ids
    instance_ids = module.servers.instance_ids
}

module "servers" {
    source = "../modules/compute"

    project_name = var.project_name
    environment = var.environment
    vpc_id = module.network.vpc_id
    subnet_ids = module.network.public_subnet_ids
    lb_security_group_id = module.loadbalancer.security_group_id
    server_count = var.server_count
    instance_type = var.server_instance_type
}

module "database" {
    source = "../modules/database"

    project_name = var.project_name
    environment = var.environment
    vpc_id = module.network.vpc_id
    subnet_ids = module.network.private_subnet_ids
    server_security_group_id = module.servers.security_group_id
    instance_class = var.db_instance_class
    allocated_storage = var.db_allocated_storage
    db_name = var.db_name
    db_username = var.db_username
    db_password = var.db_password
}

resource "aws_route53_record" "app" {
    zone_id = data.aws_route53_zone.primary.zone_id
    name = var.subdomain
    type = "A"

    alias {
      name = module.loadbalancer.dns_name
      zone_id = module.loadbalancer.zone_id
      evaluate_target_health = true
    }
}
