terraform {
  required_version = "~> 1.1.7"
}

provider "aws" {
  region = "eu-west-1"
}

module "website" {
  source = "../modules/website"

  environment = "prod"
}

module "api" {
  source = "../modules/api"

  environment = "prod"
}
