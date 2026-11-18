# Independent Dev networking; depends on Dev's Resource Group.
terraform {
  source = "../../../terraform/networking"
}

locals {
  env = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals
}

dependency "resource_group" {
  config_path = "../resource-group"
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
  resource_group_name = dependency.resource_group.outputs.resource_group_name
  location            = local.env.location
  vnet_name           = local.env.vnet_name
  vnet_cidr           = local.env.vnet_cidr
  subnet_name         = local.env.subnet_name
  subnet_cidr         = local.env.subnet_cidr
}
