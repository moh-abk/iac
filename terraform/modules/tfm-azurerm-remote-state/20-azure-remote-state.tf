#--------------------------------------------------------------
# AzureRM Remote State
#--------------------------------------------------------------

data "terraform_remote_state" "remote_state" {
  backend = "azurerm"

  config = {
    storage_account_name = var.storage_account_name
    key                  = var.key
    container_name       = var.container_name
    resource_group_name  = var.resource_group_name
    access_key           = var.storage_account_access_key
  }
}
