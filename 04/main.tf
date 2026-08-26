terraform {
  backend "s3" {
    bucket         = "tf-state-6547-04"
    key            = "tf-state/state"
    dynamodb_table = "tf-state-04"
    region         = "ap-south-1"
    encrypt        = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "network" {
  source = "./modules/network"

  project_name         = var.project_name
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

module "servers" {
  source = "./modules/compute"

  project_name  = var.project_name
  vpc_id        = module.network.vpc_id
  subnet_ids    = module.network.public_subnet_ids
  server_count  = var.server_count
  ami           = var.server_ami
  instance_type = var.server_instance_type
}

module "database" {
  source = "./modules/database"

  project_name             = var.project_name
  vpc_id                   = module.network.vpc_id
  subnet_ids               = module.network.private_subnet_ids
  server_security_group_id = module.servers.security_group_id
  db_name                  = var.db_name
  db_username              = var.db_username
  db_password              = var.db_password
}
