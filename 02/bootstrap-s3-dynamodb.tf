terraform {
  backend "s3" {
    bucket = "tf-state-tutorial-01"
    key = "tf-infra/terraform.tfstate"
    region = "ap-south-1"
    dynamodb_table = "tf-state-locking"
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
    region = "ap-south-1"
}

resource "aws_s3_bucket" "terraform_state" {
    bucket = "tf-state-tutorial-01"
    force_destroy = true
    versioning {
      enabled = true
    }
    server_side_encryption_configuration {
      rule {
        apply_server_side_encryption_by_default {
          sse_algorithm = "AES256"
        }
      }
    }
}

resource "aws_dynamodb_table" "terraform_state" {
 name = "tf-state-locking" 
 billing_mode = "PAY_PER_REQUEST"
 hash_key = "LockID"
 attribute {
   name = "LockID"
   type = "S"
 }
}