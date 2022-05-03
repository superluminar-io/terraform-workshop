terraform {
  required_version = "~> 1.1.7"

  backend "s3" {
    bucket = "terraform-state-1651593315119"
    key    = "staging/terraform.tfstate"
    region = "eu-west-1"
  }
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
