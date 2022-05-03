terraform {
  required_version = "~> 1.1.7"
}

provider "aws" {
  region = "eu-west-1"
}

resource "aws_s3_bucket" "website" {
  bucket        = "superluminar-hello-world-website"
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

variable "lambda_function_response" {
  type        = string
  description = "Body response of the hello world lambda function"
  default     = "Hello from Lambda!"
}

module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "hello-world"
  handler       = "helloworld.handler"
  runtime       = "nodejs12.x"
  source_path   = "./functions"
  environment_variables = {
    "RESPONSE" = var.lambda_function_response
  }

  publish = true
  allowed_triggers = {
    AllowExecutionFromAPIGateway = {
      service    = "apigateway"
      source_arn = "${aws_apigatewayv2_api.hello_world.execution_arn}/*/*"
    }
  }
}

resource "aws_apigatewayv2_api" "hello_world" {
  name          = "hello-world"
  protocol_type = "HTTP"
  target        = module.lambda_function.lambda_function_arn
}

output "website_url" {
  description = "Static website URL"
  value = "http://${aws_s3_bucket_website_configuration.website.website_endpoint}"
}

output "api_url" {
  description = "Hello World API URL"
  value       = aws_apigatewayv2_api.hello_world.api_endpoint
}
