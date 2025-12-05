terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "atlantis_test" {
  bucket = "mehdi-atlantis-test-bucket-12345" # <-- change to a globally-unique bucket name
}

output "bucket_name" {
  value = aws_s3_bucket.atlantis_test.bucket
}
