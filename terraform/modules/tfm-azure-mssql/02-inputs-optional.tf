variable "mssql_zone_redundant" {
  description = "Whether or not the Elastic Pool is zone redundant, SKU tier must be Premium to use it. This is mandatory for high availability."
  type        = bool
  default     = false
}

variable "mssql_server_version" {
  description = "Version of the SQL Server. Valid values are: 2.0 (for v11 server) and 12.0 (for v12 server). See https://www.terraform.io/docs/providers/azurerm/r/sql_server.html#version"
  type        = string
  default     = "12.0"
}

variable "mssql_allowed_cidr_list" {
  description = "Allowed IP addresses to access the server in CIDR format. Default to all Azure services"
  type        = list(string)
  default     = ["0.0.0.0/32"]
}

variable "mssql_databases_collation" {
  description = "SQL Collation for the databases"
  type        = string
  default     = "SQL_LATIN1_GENERAL_CP1_CI_AS"
}

variable "mssql_database_min_dtu_capacity" {
  description = "The minimum capacity all databases are guaranteed in the Elastic Pool. Defaults to 0."
  type        = string
  default     = "0"
}

variable "mssql_database_max_dtu_capacity" {
  description = "The maximum capacity any one database can consume in the Elastic Pool. Default to the max Elastic Pool capacity."
  type        = string
  default     = ""
}

variable "enable_advanced_data_security" {
  description = "Boolean flag to enable Advanced Data Security. The cost of ADS is aligned with Azure Security Center standard tier pricing. See https://docs.microsoft.com/en-us/azure/sql-database/sql-database-advanced-data-security"
  type        = bool
  default     = false
}

variable "enable_advanced_data_security_admin_emails" {
  description = "Boolean flag to define if account administrators should be emailed with Advanced Data Security alerts."
  type        = bool
  default     = false
}

variable "advanced_data_security_additional_emails" {
  description = "List of addiional email addresses for Advanced Data Security alerts."
  type        = list(string)

  # https://github.com/terraform-providers/terraform-provider-azurerm/issues/1974
  default = ["john.doe@azure.com"]
}
