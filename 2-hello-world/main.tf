terraform {
  required_version = "~> 1.1.7"
}

provider "aws" {
  region = "eu-west-1"
}

data "aws_iam_policy" "admin" {
  name = "AdministratorAccess"
}

resource "aws_iam_user" "ci" {
  name = "CI"
}

resource "aws_iam_user_policy_attachment" "ci" {
  user       = aws_iam_user.ci.name
  policy_arn = data.aws_iam_policy.admin.arn
}

variable "lambda_function_response" {
  type        = string
  description = "Body response of the hello world lambda function"
  default     = "Hello World :)"
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

output "endpoint" {
  description = "Hello World API URL"
  value       = aws_apigatewayv2_api.hello_world.api_endpoint
}
