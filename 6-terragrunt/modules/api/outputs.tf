output "endpoint" {
  description = "Hello World API URL"
  value       = aws_apigatewayv2_api.hello_world.api_endpoint
}
