resource "aws_s3_bucket" "website" {
  bucket        = "superluminar-hello-world-website-${var.environment}"
  force_destroy = true
}

resource "aws_s3_object" "startpage" {
  bucket       = aws_s3_bucket.website.id
  key          = "index.html"
  source       = "${path.module}/index.html"
  acl          = "public-read"
  content_type = "text/html"
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website.bucket

  index_document {
    suffix = "index.html"
  }
}
