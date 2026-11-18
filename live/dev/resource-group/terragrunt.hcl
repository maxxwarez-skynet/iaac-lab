# Independent Dev deployment; reuses native resource-group Terraform code.
terraform {
  source = "../../../terraform/resource-group"
}

locals {
  env = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals
}

remote_state {
  backend = "local"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    path = "${get_terragrunt_dir()}/terraform.tfstate"
  }
}

inputs = {
  name     = local.env.resource_group_name
  location = local.env.location
}
