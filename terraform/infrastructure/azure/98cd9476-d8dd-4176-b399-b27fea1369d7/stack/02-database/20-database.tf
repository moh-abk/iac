module "network_data" {
  source = "../../../../../modules/tfm-azurerm-remote-state"

  storage_account_name       = var.remote_state_storage_account_name
  storage_account_access_key = data.azurerm_key_vault_secret.devops_key_vault_secret.value
  container_name             = var.remote_state_container_name

  key = format("%s/%s/%s/01-network/%s",
    data.azurerm_subscription.current.subscription_id,
    var.remote_state_location,
    var.deploy_environment,
    var.remote_state_key_filename
  )

  resource_group_name = var.remote_state_resource_group_name
}

#--------------------------------------------------------------
# Resource Group
#--------------------------------------------------------------

resource "azurerm_resource_group" "resource_group" {
  location = var.location

  name = format("%s_%s_%s_resource_group",
    var.service_name_prefix,
    lookup(data.null_data_source.tag_defaults.inputs, "Environment"),
    var.service_shortname
  )
}

module "database" {
  source = "../../../../../modules/tfm-azure-mssql"

  mssql_administrator_login    = var.mssql_administrator_login
  mssql_administrator_password = data.azurerm_key_vault_secret.mssql_administrator_password_secret.value
  mssql_databases_names        = var.mssql_databases_names
  mssql_elastic_pool_max_size  = var.mssql_elastic_pool_max_size
  mssql_sku                    = var.mssql_sku

  network_location    = var.location
  resource_group_name = azurerm_resource_group.resource_group.name

  service_name_prefix = var.service_name_prefix
  service_shortname   = var.service_shortname

  tag_project_name         = var.tag_project_name
  tag_environment          = var.tag_environment
  tag_cost_center          = var.tag_cost_center
  tag_app_operations_owner = var.tag_app_operations_owner
  tag_system_owner         = var.tag_system_owner
  tag_budget_owner         = var.tag_budget_owner
}