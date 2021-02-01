#--------------------------------------------------------------
# MSSQL Server
#--------------------------------------------------------------

resource "azurerm_sql_server" "server" {
  name = local.server_name

  location            = var.network_location
  resource_group_name = var.resource_group_name

  version                      = var.mssql_server_version
  administrator_login          = var.mssql_administrator_login
  administrator_login_password = var.mssql_administrator_password

  tags = merge(
    data.null_data_source.tag_defaults.inputs,
    map(
      "Name", replace(
        format("%s-%s-server",
          var.service_name_prefix,
          lookup(data.null_data_source.tag_defaults.inputs, "Environment")
        ),
        "_",
        "-"
      )
    )
  )
}

resource "azurerm_sql_firewall_rule" "firewall_rule" {
  count = length(var.mssql_allowed_cidr_list)

  name                = "rule-${count.index}"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_sql_server.server.name

  start_ip_address = cidrhost(var.mssql_allowed_cidr_list[count.index], 0)
  end_ip_address   = cidrhost(var.mssql_allowed_cidr_list[count.index], -1)
}

resource "azurerm_mssql_elasticpool" "elastic_pool" {
  name = local.elastic_pool_name

  location            = var.network_location
  resource_group_name = var.resource_group_name

  server_name = azurerm_sql_server.server.name

  per_database_settings {
    max_capacity = coalesce(var.mssql_database_max_dtu_capacity, var.mssql_sku.capacity)
    min_capacity = var.mssql_database_min_dtu_capacity
  }

  max_size_gb    = var.mssql_elastic_pool_max_size
  zone_redundant = var.mssql_zone_redundant

  sku {
    capacity = local.elastic_pool_sku.capacity
    name     = local.elastic_pool_sku.name
    tier     = local.elastic_pool_sku.tier
  }

  tags = merge(
    data.null_data_source.tag_defaults.inputs,
    map(
      "Name", replace(
        format("%s-%s-elastic-pool",
          var.service_name_prefix,
          lookup(data.null_data_source.tag_defaults.inputs, "Environment")
        ),
        "_",
        "-"
      )
    )
  )
}

resource "azurerm_sql_database" "db" {
  count = length(var.mssql_databases_names)

  name                = var.mssql_databases_names[count.index]
  location            = var.network_location
  resource_group_name = var.resource_group_name

  server_name = azurerm_sql_server.server.name
  collation   = var.mssql_databases_collation

  requested_service_objective_name = "ElasticPool"
  elastic_pool_name                = azurerm_mssql_elasticpool.elastic_pool.name

  threat_detection_policy {
    email_account_admins = var.enable_advanced_data_security_admin_emails ? "Enabled" : "Disabled"
    email_addresses      = var.advanced_data_security_additional_emails
    state                = var.enable_advanced_data_security ? "Enabled" : "Disabled"
  }

  tags = merge(
    data.null_data_source.tag_defaults.inputs,
    map(
      "Name", replace(
        format("%s-%s-%s-database",
          var.service_name_prefix,
          var.mssql_databases_names[count.index],
          lookup(data.null_data_source.tag_defaults.inputs, "Environment")
        ),
        "_",
        "-"
      )
    )
  )
}