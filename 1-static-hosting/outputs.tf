output "website_url" {
  description = "Static website URL"
  value = "http://${aws_s3_bucket_website_configuration.website.website_endpoint}"
}
