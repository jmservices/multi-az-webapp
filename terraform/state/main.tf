provider "aws" {
  region = "${var.region}"
}

resource "aws_s3_bucket" "state_bucket" {
  bucket = "${var.s3_name}"
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name        = "TF WebApp State"
    Environment = "DevOps"
  }
}