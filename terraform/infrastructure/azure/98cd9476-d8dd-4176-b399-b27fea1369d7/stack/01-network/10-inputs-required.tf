# General
variable "deploy_environment" {}
variable "location" {}

# Network
variable "network_address_space" {}
variable "network_shortname" {}
variable "dmz_subnet_cidr_blocks" {}
variable "public_subnet_cidr_blocks" {}
variable "private_subnet_cidr_blocks" {}
variable "application_gateway_subnet_cidr_blocks" {}

# Tags
variable "tag_project_name" {}
variable "tag_environment" {}
variable "tag_cost_center" {}
variable "tag_app_operations_owner" {}
variable "tag_system_owner" {}
variable "tag_budget_owner" {}
