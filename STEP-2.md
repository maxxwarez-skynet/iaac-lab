# IAAC Lab — Step 2: Networking

This add-on **does not overwrite Step 1**. Copy the `terraform/networking` and
`live/networking` directories into the root of your existing `iaac-lab` checkout.

## What changes?

- One VNet (`vnet-iaac-lab`) with address space `10.42.0.0/16`.
- One subnet (`snet-iaac-lab`) with CIDR `10.42.1.0/24`.
- A distinct local state at `live/networking/terraform.tfstate`.
- A Terragrunt `dependency` that reads the existing Resource Group output.

## Before deploying

1. Keep the Step 1 Resource Group deployed, with its original local state intact.
2. Run from the **same machine/checkout** where Step 1 was applied; Terragrunt
   reads the existing state file to resolve the dependency.
3. Verify your Azure CLI account and intended subscription:

```bash
az account show --output table
export ARM_SUBSCRIPTION_ID="$(az account show --query id -o tsv)"
export TG_TF_PATH="$(command -v tofu)"
```

`ARM_SUBSCRIPTION_ID` must be the intended lab subscription. If Step 1's
provider explicitly pins a subscription, confirm both target the same one.

## Execute networking only

```bash
cd live/networking
terragrunt init
terragrunt plan
terragrunt apply
terragrunt output
terragrunt state list
```

Expected new resources: 1 `azurerm_virtual_network` and 1 `azurerm_subnet`.
Terragrunt does not need to re-apply Resource Group when applying networking
alone; its `dependency` reads the already-created Resource Group output.

## Important

- Preserve the existing `live/resource-group/terraform.tfstate`. Do not commit
  or delete state files. The repo `.gitignore` already excludes them.
- `terragrunt run --all apply` would run multiple units in dependency order,
  but **do not use a multi-unit apply yet**: we're learning unit boundaries.
- Never destroy the Resource Group while Networking still exists; Resource
  Group deletion can remove the network too. When cleaning up, destroy
  Networking first, then the Resource Group.
- This lab's local backend is not suitable for shared/team operation.

## Why separate state?

Terraform controls dependencies **within** networking: its subnet references
`azurerm_virtual_network.this.name`. Terragrunt controls the relationship
**between** networking and the separately managed Resource Group unit.
