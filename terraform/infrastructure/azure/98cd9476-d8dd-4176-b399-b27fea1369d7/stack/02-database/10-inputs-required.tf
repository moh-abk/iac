# General
variable "deploy_environment" {}
variable "location" {}

# Remote State
variable "devops_key_vault" {}
variable "remote_state_storage_account_access_key" {}
variable "remote_state_storage_account_name" {}
variable "remote_state_resource_group_name" {}
variable "remote_state_container_name" {}

# Service
variable "service_shortname" {}
variable "service_name_prefix" {}

# Database
variable "mssql_administrator_login" {}
variable "mssql_databases_names" {}
variable "mssql_elastic_pool_max_size" {}
variable "mssql_sku" {}

# Tags
variable "tag_project_name" {}
variable "tag_environment" {}
variable "tag_cost_center" {}
variable "tag_app_operations_owner" {}
variable "tag_system_owner" {}
variable "tag_budget_owner" {}
