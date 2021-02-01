resource "azurerm_resource_group" "network_resource_group" {
  location = var.location

  name = format("%s_%s_network_resource_group",
    lookup(data.null_data_source.network_defaults.inputs, "name_prefix"),
    lookup(data.null_data_source.tag_defaults.inputs, "Environment")
  )
}

module "network" {
  source = "../../../../../modules/tfm-azure-network"

  resource_group_name = azurerm_resource_group.network_resource_group.name
  dns_suffix          = var.dns_suffix

  deploy_environment = var.deploy_environment

  network_address_space = var.network_address_space
  network_location      = var.location
  network_shortname     = var.network_shortname

  dmz_subnet_cidr_blocks                 = var.dmz_subnet_cidr_blocks
  public_subnet_cidr_blocks              = var.public_subnet_cidr_blocks
  private_subnet_cidr_blocks             = var.private_subnet_cidr_blocks
  application_gateway_subnet_cidr_blocks = var.application_gateway_subnet_cidr_blocks

  tag_project_name         = var.tag_project_name
  tag_environment          = var.tag_environment
  tag_cost_center          = var.tag_cost_center
  tag_app_operations_owner = var.tag_app_operations_owner
  tag_system_owner         = var.tag_system_owner
  tag_budget_owner         = var.tag_budget_owner
}
