output "website_url" {
  description = "Static website URL"
  value       = "http://${aws_s3_bucket_website_configuration.website.website_endpoint}"
}

output "api_url" {
  description = "Hello World API URL"
  value       = aws_apigatewayv2_api.hello_world.api_endpoint
}
