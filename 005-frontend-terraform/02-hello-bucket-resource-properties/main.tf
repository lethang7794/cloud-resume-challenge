provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_s3_bucket" "main" {
  bucket              = "my-bucket-0fiesvn0oj"
  object_lock_enabled = true
}
