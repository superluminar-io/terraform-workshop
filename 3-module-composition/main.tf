terraform {
  required_version = "~> 1.1.7"

  backend "s3" {
    key    = "terraform.tfstate"
    region = "eu-west-1"
  }
}

provider "aws" {
  region = "eu-west-1"
}

module "website" {
  source = "./modules/website"
}

module "api" {
  source = "./modules/api"
}
