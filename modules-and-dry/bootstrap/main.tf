provider "aws" {
  region = "ap-south-1"
}

resource "aws_s3_bucket" "tf-state" {
  bucket = "tf-state-6547-04"
}

resource "aws_s3_bucket_versioning" "tf-state-version" {
  bucket = aws_s3_bucket.tf-state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tf-state-encrypt" {
  bucket = aws_s3_bucket.tf-state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_dynamodb_table" "tf-state-dynamodb" {
  name         = "tf-state-04"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
