variable "resource_group_name" {}
variable "network_location" {}

variable "service_shortname" {}
variable "service_name_prefix" {}

variable "network_name" {}
variable "network_shortname" {}
variable "network_resource_group_name" {}

variable "vmss_instances_count" {}
variable "vmss_minimum_instances_count" {}
variable "vmss_maximum_instances_count" {}
variable "vmss_admin_username" {}
variable "vmss_admin_password" {}
variable "vmss_source_image_id" {}

# Tags
variable "tag_project_name" {}
variable "tag_environment" {}
variable "tag_cost_center" {}
variable "tag_app_operations_owner" {}
variable "tag_system_owner" {}
variable "tag_budget_owner" {}
