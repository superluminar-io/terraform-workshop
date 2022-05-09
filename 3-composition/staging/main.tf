terraform {
  required_version = "~> 1.1.7"
}

provider "aws" {
  region = "eu-west-1"
}

module "website" {
  source = "../modules/website"
  
  environment = "staging"
}

module "api" {
  source = "../modules/api"
  
  lambda_function_response = "Hello from Staging 👋"
  environment = "staging"
}