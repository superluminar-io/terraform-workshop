terraform {
  required_version = "~> 1.1.7"

  backend "s3" {
    key    = "staging/terraform.tfstate"
    region = "eu-central-1"
  }
}

provider "aws" {
  region = "eu-central-1"
}

module "website" {
  source = "../modules/website"

  environment = "staging"
}

module "api" {
  source = "../modules/api"

  environment             = "staging"
  enable_greeting_feature = true
}
