terraform {
  backend "s3" {
    bucket         = "mehdi-platform-tf-state"
    key            = "notes-app/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
  }
} 