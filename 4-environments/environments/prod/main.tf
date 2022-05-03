terraform {
  required_version = "~> 1.1.7"
}

provider "aws" {
  region = "eu-west-1"
}

module "api" {
  source = "../../modules/api"
  
  lambda_function_response = "Hello from Prod 👋"
  environment = "prod"
}
