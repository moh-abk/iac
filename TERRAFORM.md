# Terraform
Terraform is a tool for building, changing, and versioning infrastructure safely and efficiently. Terraform can manage existing and popular service providers as well as custom in-house solutions.

## General Terraform Style Guide
Terraform files should obey the syntax rules for the HashiCorp Configuration Language (HCL) and the general formatting guidelines provided by the Terraform Project through the fmt command.

In addition, we use the following standards when writing Terraform:
* Use Snake Case for all resource names
* Declare all outputs in outputs.tf
* Pin all providers to a specific version or tag
* Always use relative paths and the file() helper
* Prefer separate resources over inline blocks
* Terraform versions and provider versions should be pinned, as it's not possible to safely downgrade a state file once it has been used with a newer version of Terraform

## Key Concepts
###Account/Subscription Environment 
A collection of one or more stacks defined within a single account or subscription folder. An account environment describes the complete infrastructure deployed for a single account or subscription.

```shell
.
├── infrastructure
│   └── azure
│       ├── 98cd9476-d8dd-4176-b399-b27fea1369d7 # account/subscription environment
```

###Stack 
A stack is a logical grouping of related resources, data sources, and modules that should be managed together by Terraform. Stacks are used to break complex environments into multiple logical subsets. Each stack should independently define configuration for all needed providers. Stacks represent different application tiers, like "database", "web server", or "network". When designing stacks, the following considerations should be taken:
* Resources that are frequently modified together should be in the same stack, for example an EC2 instance, and its related IAM Role and policies should remain in a single layer.
* Smaller stacks will limit blast radius and make Terraform state refreshes and updates quicker and safer.
* Dependencies between layers should always flow one way, taking 01-base, 02-network, and 03-eks layers as an example, 01-base should not reference anything in 02-network or 03-eks, and 02-network should not reference anything in 03-eks.
* Use a data source to read another stack's state. Never write to another stack's state directly.

###Module 
Module is a collection of connected resources which together perform the common action (for example, vpc module creates VPC, subnets, NAT gateway, etc). It depends on provider configuration(s), which should normally be defined at a higher level.

```shell
.
├── tfm-azure-mssql
│   ├── 00-init.tf
│   ├── 01-inputs-required.tf
│   ├── 02-inputs-optional.tf
│   ├── 03-interpolated-defaults.tf
│   ├── 10-mssql.tf
│   └── 99-outputs.tf
├── tfm-azure-network
│   ├── 00-init.tf
│   ├── 01-inputs-required.tf
│   ├── 02-inputs-optional.tf
│   ├── 03-interpolated-defaults.tf
│   ├── 10-network.tf
│   ├── 12-connectivity.tf
│   ├── 18-debug-outputs.tf
│   ├── 19-network-outputs.tf
│   ├── 20-connectivity-outputs.tf
│   └── 99-outputs.tf
├── tfm-azure-vmss
│   ├── 00-init.tf
│   ├── 01-inputs-required.tf
│   ├── 02-inputs-optional.tf
│   ├── 03-interpolated-defaults.tf
│   ├── 10-networking.tf
│   ├── 11-vmss.tf
│   └── 99-outputs.tf
└── tfm-azurerm-remote-state
    ├── 00-init.tf
    ├── 10-inputs-required.tf
    ├── 11-inputs-defaults.tf
    ├── 20-azure-remote-state.tf
    └── 99-outputs.tf
```

###Resource 
Resource is `azurerm_virtual_network`, `azurerm_subnet`, and so on. Resource belongs to provider, accepts arguments, outputs attributes and has lifecycles. Resource can be created, retrieved, updated, and deleted.

###Data Source 
Data source performs read-only operation and is dependent on provider configuration, it can be used in modules and layers to lookup information about the Account Environment.
Data source terraform_remote_state can be used to output from one layer to another.

## Code Structure
###Layout
The following `tree` diagram shows how the code is structured:

```shell
├── terraform
│   ├── infrastructure
│   │   └── azure
│   │       ├── 98cd9476-d8dd-4176-b399-b27fea1369d7
│   │       │   └── stack
│   │       │       ├── 01-network
│   │       │       │   ├── 00-init.tf
│   │       │       │   ├── 10-inputs-required.tf
│   │       │       │   ├── 11-inputs-default.tf
│   │       │       │   ├── 12-interpolated-defaults.tf
│   │       │       │   ├── 20-network.tf
│   │       │       │   ├── 99-outputs.tf
│   │       │       │   └── apply.tfplan
│   │       │       ├── 02-database
│   │       │       │   ├── 00-init.tf
│   │       │       │   ├── 10-inputs-required.tf
│   │       │       │   ├── 11-inputs-default.tf
│   │       │       │   ├── 12-interpolated-defaults.tf
│   │       │       │   ├── 20-database.tf
│   │       │       │   ├── 99-outputs.tf
│   │       │       │   └── apply.tfplan
│   │       │       └── 03-compute
│   │       │           ├── 00-init.tf
│   │       │           ├── 10-inputs-required.tf
│   │       │           ├── 11-inputs-default.tf
│   │       │           ├── 12-interpolated-defaults.tf
│   │       │           ├── 20-compute.tf
│   │       │           └── 99-outputs.tf
│   │       ├── _terraform_cmds
│   │       └── terraform.sh
```

Terraform configuration follows the above structure:

```shell
.
└── azure
    └── vars
        ├── 98cd9476-d8dd-4176-b399-b27fea1369d7
        │   ├── UK\ South
        │   │   ├── common.tfvars.json
        │   │   └── dev
        │   │       ├── 01-network
        │   │       │   └── config.tfvars.json
        │   │       ├── 02-database
        │   │       │   └── config.tfvars.json
        │   │       ├── 03-compute
        │   │       │   └── config.tfvars.json
        │   │       └── common.tfvars.json
        │   └── common.tfvars.json
        └── common.tfvars.json
```

## Execution

To achieve a great level of flexibility and support for various levels of configuration, a helper script has been created 
which wraps all the common `terraform` commands.

```shell
~ ./terraform.sh                                                                                                                                                                                                                                                                               ✔  5425  11:05:44
./terraform.sh SUBSCRIPTION_ID ENVIRONMENT LOCATION COMPONENT COMMAND [EXTRA_TERRAFORM_PARAMS]

account_id: SUBSCRIPTION_ID to provision on
region: Deployment region
commands: get plan apply plan_destroy destroy show_state
```

### Plan & Apply

```shell
export ARM_SUBSCRIPTION_ID=
export ARM_TENANT_ID=
export ARM_CLIENT_ID=
export ARM_CLIENT_SECRET=

./terraform.sh <SUBSCRIPTION_ID> <ENVIRONMENT> <LOCATION> 01-network plan
./terraform.sh <SUBSCRIPTION_ID> <ENVIRONMENT> <LOCATION> 01-network apply

./terraform.sh <SUBSCRIPTION_ID> <ENVIRONMENT> <LOCATION> 02-database plan
./terraform.sh <SUBSCRIPTION_ID> <ENVIRONMENT> <LOCATION> 02-database apply

./terraform.sh <SUBSCRIPTION_ID> <ENVIRONMENT> <LOCATION> 03-compute plan -var vmss_source_image_id="" # passed inline once Packer build is complete.
./terraform.sh <SUBSCRIPTION_ID> <ENVIRONMENT> <LOCATION> 03-compute apply
```