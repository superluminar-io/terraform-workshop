output "url" {
  description = "Hello World Website URL"
  value       = "http://${aws_s3_bucket_website_configuration.website.website_endpoint}"
}
