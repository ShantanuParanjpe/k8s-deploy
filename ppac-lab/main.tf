provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "bad_bucket" {
bucket = "my-ppac-demo-bucket-12345"
acl    = "public-read"
}


