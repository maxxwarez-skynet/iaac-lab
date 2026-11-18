# A second Terraform root and independently managed state.
terraform {
  source = "../../terraform/networking"
}

# The resource group must already have been applied, so its outputs exist.
# This block also places resource-group before networking in a multi-unit run.
dependency "resource_group" {
  config_path = "../resource-group"
}

# Lab-only local state, separate from resource-group state.
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
  location            = "centralindia"
  vnet_name           = "vnet-iaac-lab"
  vnet_cidr           = "10.42.0.0/16"
  subnet_name         = "snet-iaac-lab"
  subnet_cidr         = "10.42.1.0/24"
}
