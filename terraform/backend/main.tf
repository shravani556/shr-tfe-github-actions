provider "aws" {
  region = "us-east-1"
}

# S3 Bucket for Terraform state
resource "aws_s3_bucket" "tfstate" {
  bucket        = "shr-tfe-statefile-bucket"
  force_destroy = true
}

# Enable versioning separately
resource "aws_s3_bucket_versioning" "tfstate_versioning" {
  bucket = aws_s3_bucket.tfstate.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption separately
resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate_encryption" {
  bucket = aws_s3_bucket.tfstate.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Optional: Block public access (good security practice)
resource "aws_s3_bucket_public_access_block" "tfstate_block_public" {
  bucket = aws_s3_bucket.tfstate.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Optional: Set ownership control (recommended to avoid ACL issues)
resource "aws_s3_bucket_ownership_controls" "tfstate_ownership" {
  bucket = aws_s3_bucket.tfstate.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# DynamoDB table for state locking
resource "aws_dynamodb_table" "terraform_lock" {
  name         = "shr-terraform-lock-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
