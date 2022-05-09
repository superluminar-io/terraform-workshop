terraform {
  required_version = "~> 1.1.7"
}

provider "aws" {
  region = "eu-west-1"
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

module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "hello-world"
  handler       = "helloworld.handler"
  runtime       = "nodejs12.x"
  source_path   = "./functions"
  environment_variables = {
    "RESPONSE" = "Hello from Lambda! 👋"
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
