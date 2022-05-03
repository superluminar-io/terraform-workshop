terraform {
  required_version = "~> 1.1.7"
}

provider "aws" {
  region = "eu-west-1"
}

resource "aws_s3_bucket" "website" {
  bucket = "superluminar-hello-world-website"
  force_destroy = true
}

resource "aws_s3_object" "startpage" {
  bucket = aws_s3_bucket.website.id
  key    = "index.html"
  source = "index.html"
  acl = "public-read"
  content_type = "text/html"
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website.bucket

  index_document {
    suffix = "index.html"
  }
}

output "website_url" {
  description = "Static website URL"
  value = "http://${aws_s3_bucket_website_configuration.website.website_endpoint}"
}
