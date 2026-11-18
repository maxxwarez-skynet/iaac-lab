# IAAC Lab — Second independent environment

Existing deployed units at `live/resource-group` and `live/networking` remain unchanged, including their local state files.

New Dev environment:

```text
live/dev/
├── env.hcl
├── resource-group/terragrunt.hcl
└── networking/terragrunt.hcl
```

Both environments reference the same native Terraform code under `terraform/`. Dev has distinct resource names, CIDRs, and local state paths.

## Before deploying

1. In the checkout where you deployed the original lab, run `git switch dev && git pull`.
2. Check `az account show --output table`. Confirm the organization subscription is appropriate for the lab.
3. Keep your existing environment's state files; never commit Terraform state.
4. Ensure `tofu` is installed and set `export TG_TF_PATH="$(command -v tofu)"`. If applicable, set `export ARM_SUBSCRIPTION_ID="$(az account show --query id -o tsv)"`.
5. If a Terraform provider block explicitly pins a subscription ID, ensure that ID matches your intended subscription.

## Deploy Dev with reviewed plans

From the repository root:

```bash
cd live/dev/resource-group
terragrunt init
terragrunt plan
terragrunt apply

cd ../networking
terragrunt init
terragrunt plan
terragrunt apply

cd ..
terragrunt run --all plan
```

Expected Dev Azure resources: RG `rg-iaac-dev`, VNet `vnet-iaac-dev` (`10.43.0.0/16`), subnet `snet-iaac-dev` (`10.43.1.0/24`). On a fresh Dev environment, `terragrunt run --all plan` before creating Dev RG may fail when reading its output, because its state does not yet exist; this lab deliberately avoids mock outputs.

## Explanation

- Terraform definitions are shared across the original lab and Dev.
- Terragrunt supplies distinct Dev inputs from `live/dev/env.hcl`.
- Each Terragrunt unit has its own local state file under its unit directory.
- Dev Networking reads the **Dev** Resource Group's output, not the original lab's output.
- No existing state files are moved or migrated; no CI/CD is involved.

Destroy Dev in reverse order (`live/dev/networking`, then `live/dev/resource-group`) only when it is safe to delete those Azure resources.
