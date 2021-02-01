data "azurerm_subscription" "current" {}
data "azurerm_client_config" "current" {}

data "null_data_source" "tag_defaults" {
  inputs = {
    Project_Name         = var.tag_project_name
    Environment          = var.tag_environment
    Cost_Center          = var.tag_cost_center
    App_Operations_Owner = var.tag_app_operations_owner
    System_Owner         = var.tag_system_owner
    Budget_Owner         = var.tag_budget_owner
    Created_By           = "Terraform"
  }
}

data "azurerm_key_vault_secret" "devops_key_vault_secret" {
  name         = var.remote_state_storage_account_access_key
  key_vault_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/genesis_resource_group/providers/Microsoft.KeyVault/vaults/${var.devops_key_vault}"
}

data "azurerm_key_vault_secret" "vmss_administrator_password_secret" {
  name         = "tfm-vmss-password"
  key_vault_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/genesis_resource_group/providers/Microsoft.KeyVault/vaults/${var.devops_key_vault}"
}
