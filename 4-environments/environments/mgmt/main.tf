terraform {
  required_version = "~> 1.1.7"
}

provider "aws" {
  region = "eu-west-1"
}

module "mgmt" {
  source = "../../modules/mgmt"
}
