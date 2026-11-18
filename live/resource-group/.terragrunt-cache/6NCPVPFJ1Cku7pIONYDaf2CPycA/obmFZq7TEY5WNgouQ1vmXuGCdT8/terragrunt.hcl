# Tell Terragrunt which native OpenTofu/Terraform configuration to run.
terraform {
  source = "../../terraform/resource-group"
}

# Lab-only local state: kept outside Terragrunt's temporary source cache.
# The generate stanza writes a backend.tf into the working copy.
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

# Values passed into variables.tf.
inputs = {
  name     = "rg-iaac-lab"
  location = "centralindia"
}
