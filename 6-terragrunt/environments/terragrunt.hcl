remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket = "superluminar-terraform-workshop-${get_aws_account_id()}-${path_relative_to_include()}-state"

    key = "terraform.tfstate"
    region         = "eu-west-1"
    encrypt        = true
    dynamodb_table = "superluminar-terraform-workshop-${get_aws_account_id()}-${path_relative_to_include()}-lock-table"
  }
}

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "aws" {
  region = "eu-west-1"
}
EOF
}

