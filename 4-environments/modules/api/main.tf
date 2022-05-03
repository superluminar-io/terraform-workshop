module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "hello-world-${var.environment}"
  handler       = "helloworld.handler"
  runtime       = "nodejs12.x"
  source_path   = "${path.module}/functions"
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
  name          = "hello-world-${var.environment}"
  protocol_type = "HTTP"
  target        = module.lambda_function.lambda_function_arn
}
