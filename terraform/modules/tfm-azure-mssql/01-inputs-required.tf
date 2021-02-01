variable "resource_group_name" {}

variable "network_location" {}

variable "service_shortname" {}
variable "service_name_prefix" {}

variable "mssql_administrator_login" {}
variable "mssql_administrator_password" {}

variable "mssql_elastic_pool_max_size" {}
variable "mssql_databases_names" {
  type = list(string)
}
variable "mssql_sku" {
  type = map(string)
}

# Tags
variable "tag_project_name" {}
variable "tag_environment" {}
variable "tag_cost_center" {}
variable "tag_app_operations_owner" {}
variable "tag_system_owner" {}
variable "tag_budget_owner" {}
