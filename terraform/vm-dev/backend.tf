terraform {
  backend "s3" {
    bucket         = "shr-tfe-statefile-bucket"
    key            = "vm/dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "shr-terraform-lock-table"
    encrypt        = true
  }
}
