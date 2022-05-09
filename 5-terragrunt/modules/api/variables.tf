variable "lambda_function_response" {
  type = string
  description = "Body response of the hello world lambda function"
  default = "Hello World :)"
}

variable "environment" {
  type = string
  description = "Identifier for the environment (e.g. staging, development or prod)"
}
