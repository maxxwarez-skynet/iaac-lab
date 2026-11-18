# IAAC Lab — Step 1: Azure Resource Group

A minimal, drop-in **OpenTofu + Terragrunt** experiment. One Azure Resource Group, one Terragrunt deployment unit, and one **local** state file. No GitLab, orchestration graph, multi-environment configuration, or Azure state-storage bootstrap.

## Files

```text
iaac-lab/
├── terraform/
│   └── resource-group/
│       ├── main.tf          # Azure resource declaration
│       ├── variables.tf     # Input definitions
│       ├── providers.tf     # AzureRM provider requirements
│       └── outputs.tf       # Export the name and Azure resource ID
└── live/
    └── resource-group/
        └── terragrunt.hcl   # Source, local state path, and input values
```

## Prerequisites

- `tofu` (OpenTofu) installed and available on `PATH`
- `terragrunt` installed and available on `PATH`
- `az` (Azure CLI) installed
- An Azure subscription where you can create and delete a dedicated resource group

## Run (macOS / Linux / Bash)

From the extracted `iaac-lab` directory:

```bash
az login
az account set --subscription "<your-subscription-id>"
export ARM_SUBSCRIPTION_ID="<your-subscription-id>"
export TG_TF_PATH="$(command -v tofu)"
cd live/resource-group
terragrunt init
terragrunt plan
terragrunt apply
terragrunt output
terragrunt state list
```

## Run (PowerShell)

From the extracted `iaac-lab` directory:

```powershell
az login
az account set --subscription "<your-subscription-id>"
$env:ARM_SUBSCRIPTION_ID = "<your-subscription-id>"
$env:TG_TF_PATH = (Get-Command tofu).Source
Set-Location live/resource-group
terragrunt init
terragrunt plan
terragrunt apply
terragrunt output
terragrunt state list
```

Review the plan before approving the apply. The default resource group name is `rg-iaac-lab` in `centralindia`. Change these values in `live/resource-group/terragrunt.hcl` if needed.

## Cleanup

From `live/resource-group`:

```bash
terragrunt destroy
```

**Warning:** Destroying an Azure Resource Group can also delete resources inside it. Only use an empty, dedicated lab resource group. Do not reuse the name of an existing resource group.

## Where is the state?

After a successful apply, the file is:

```text
live/resource-group/terraform.tfstate
```

Terragrunt runs OpenTofu from a generated working copy in `.terragrunt-cache`, but the absolute backend path above keeps the state in the lab's `live` directory. The local state file can contain sensitive values in general: don't commit or share it. This is intentionally **not a production backend**.

## Troubleshooting

- `tofu: command not found`: install OpenTofu and set `TG_TF_PATH` to the actual binary path.
- `subscription ID could not be determined`: confirm `ARM_SUBSCRIPTION_ID` is set in the shell invoking Terragrunt, and that `az account show` points at the intended subscription.
- `AuthorizationFailed`: check permissions on the selected Azure subscription.
- Resource group already exists: use a unique name or stop; do **not** import or destroy someone else's existing resource group for this lab.
- If you change the backend path after creating state, first learn the safe state-migration process; do not simply delete the existing state.

## Learning goal

- OpenTofu declares and manages the Azure resource.
- Terragrunt points to the root configuration, supplies inputs, and configures its state backend.
- There is just one unit, so Terragrunt is **not doing dependency orchestration yet**.

This lab has been assembled and statically checked, but **not applied to Azure** from this environment.
