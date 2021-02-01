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

locals {
  nsg_inbound_rules = { for idx, security_rule in var.vmss_nsg_inbound_rules : security_rule.name => {
    idx : idx,
    security_rule : security_rule,
    }
  }
}

data "azurerm_subnet" "public" {
  name = format("%s_public_%s",
    var.network_shortname,
    var.tag_environment
  )

  virtual_network_name = var.network_name
  resource_group_name  = var.network_resource_group_name
}
