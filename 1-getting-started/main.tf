terraform {
  required_version = "~> 1.1.7"
}

provider "aws" {
  region = "eu-central-1"
}

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "website" {
  bucket        = "hello-world-website-${data.aws_caller_identity.current.account_id}"
  force_destroy = true
}

resource "aws_s3_object" "startpage" {
  bucket       = aws_s3_bucket.website.id
  key          = "index.html"
  source       = "index.html"
  acl          = "public-read"
  content_type = "text/html"
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website.bucket

  index_document {
    suffix = "index.html"
  }
}
