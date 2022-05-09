output "api_url" {
  description = "Hello World API URL"
  value       = module.api.url
}

output "website_url" {
  description = "Static Website URL"
  value       = module.website.url
}
