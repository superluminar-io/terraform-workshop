include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../..//modules/api"
}

inputs = {
  environment = "staging"
  enable_greeting = true
}
