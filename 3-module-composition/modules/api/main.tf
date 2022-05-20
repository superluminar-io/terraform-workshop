module "lambda_function" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "3.2.0"

  function_name = "hello-world"
  handler       = "helloworld.handler"
  runtime       = "nodejs14.x"
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
  name          = "hello-world"
  protocol_type = "HTTP"
  target        = module.lambda_function.lambda_function_arn
}
