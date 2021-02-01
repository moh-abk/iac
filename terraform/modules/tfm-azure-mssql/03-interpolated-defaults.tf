data "azurerm_client_config" "current" {}

locals {
  name_prefix = var.service_name_prefix != "" ? replace(var.service_name_prefix, "/[a-z0-9]$/", "$0-") : ""

  server_name = coalesce(
    var.service_shortname,
    "${local.name_prefix}-${var.network_location}-${var.tag_environment}-sql",
  )
  elastic_pool_name = coalesce(
    var.service_shortname,
    "${local.name_prefix}-${var.network_location}-${var.tag_environment}-pool",
  )

  elastic_pool_sku = {
    name     = format("%sPool", var.mssql_sku.tier)
    capacity = var.mssql_sku.capacity
    tier     = var.mssql_sku.tier
  }
}

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
