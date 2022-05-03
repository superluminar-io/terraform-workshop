include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../..//modules/api"
}

inputs = {
  lambda_function_response = "Hello from Prod 👋"
  environment = "prod"
}
