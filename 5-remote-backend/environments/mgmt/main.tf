terraform {
  required_version = "~> 1.1.7"

  backend "s3" {
    bucket = "terraform-state-1651593315119"
    key    = "mgmt/terraform.tfstate"
    region = "eu-west-1"
  }
}

provider "aws" {
  region = "eu-west-1"
}

module "mgmt" {
  source = "../../modules/mgmt"
}
