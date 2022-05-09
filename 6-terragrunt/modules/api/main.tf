locals {
  project_name = "hello-world"
}

module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "${local.project_name}-${var.environment}"
  handler       = "helloworld.handler"
  runtime       = "nodejs12.x"
  source_path   = "${path.module}/functions"

  publish = true
  allowed_triggers = {
    AllowExecutionFromAPIGateway = {
      service    = "apigateway"
      source_arn = "${aws_apigatewayv2_api.hello_world.execution_arn}/*/*"
    }
  }
}

resource "aws_apigatewayv2_api" "hello_world" {
  name          = "${local.project_name}-${var.environment}"
  protocol_type = "HTTP"
  target        = module.lambda_function.lambda_function_arn
}
