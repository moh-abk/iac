data "null_data_source" "db_outputs" {
  inputs = {
    db_resource_group  = var.resource_group_name
    db_server_id       = azurerm_sql_server.server.id
    db_elastic_pool_id = azurerm_mssql_elasticpool.elastic_pool.id
    db_server_fqdn     = azurerm_sql_server.server.fully_qualified_domain_name
    db_database_id     = join("", azurerm_sql_database.db.*.id)
  }
}

output "db_result" {
  value = data.null_data_source.db_outputs.inputs
}

output "db_result_json" {
  value = jsonencode(data.null_data_source.db_outputs.inputs)
}
