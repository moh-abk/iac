variable "vmss_assign_public_ip_to_each_vm_in_vmss" {
  description = "Create a virtual machine scale set that assigns a public IP address to each VM"
  default     = false
}

variable "vmss_availability_zones" {
  description = "A list of Availability Zones in which the Virtual Machines in this Scale Set should be created in"
  default     = [1, 2, 3]
}

variable "vmss_overprovision" {
  description = "Should Azure over-provision Virtual Machines in this Scale Set? This means that multiple Virtual Machines will be provisioned and Azure will keep the instances which become available first - which improves provisioning success rates and improves deployment time. You're not billed for these over-provisioned VM's and they don't count towards the Subscription Quota. Defaults to true."
  default     = false
}

variable "vmss_virtual_machine_size" {
  description = "The Virtual Machine SKU for the Scale Set, Default is Standard_A2_V2"
  default     = "Standard_A2_v2"
}

variable "vmss_os_disk_storage_account_type" {
  description = "The Type of Storage Account which should back this the Internal OS Disk. Possible values include Standard_LRS, StandardSSD_LRS and Premium_LRS."
  default     = "StandardSSD_LRS"
}

variable "vmss_enable_ip_forwarding" {
  description = "Should IP Forwarding be enabled? Defaults to false"
  default     = false
}

variable "vmss_enable_accelerated_networking" {
  description = "Should Accelerated Networking be enabled? Defaults to false."
  default     = false
}

variable "vmss_availability_zone_balance" {
  description = "Should the Virtual Machines in this Scale Set be strictly evenly distributed across Availability Zones?"
  default     = true
}

variable "vmss_single_placement_group" {
  description = "Allow to have cluster of 100 VMs only"
  default     = true
}

variable "vmss_license_type" {
  description = "Specifies the type of on-premise license which should be used for this Virtual Machine. Possible values are None, Windows_Client and Windows_Server."
  default     = "None"
}

variable "vmss_os_upgrade_mode" {
  description = "Specifies how Upgrades (e.g. changing the Image/SKU) should be performed to Virtual Machine Instances. Possible values are Automatic, Manual and Rolling. Defaults to Automatic"
  default     = "Manual"
}

variable "vmss_enable_automatic_instance_repair" {
  description = "Should the automatic instance repair be enabled on this Virtual Machine Scale Set?"
  default     = false
}

variable "vmss_grace_period" {
  description = "Amount of time (in minutes, between 30 and 90, defaults to 30 minutes) for which automatic repairs will be delayed."
  default     = "PT30M"
}

variable "vmss_nat_pool_frontend_ports" {
  description = "Optional override for default NAT ports"
  type        = list(number)
  default     = [50000, 50119]
}

variable "vmss_nsg_inbound_rules" {
  description = "List of network rules to apply to network interface."
  default = [
    {
      name                   = "http"
      destination_port_range = "80"
      source_address_prefix  = "*"
    },
    {
      name                   = "https"
      destination_port_range = "443"
      source_address_prefix  = "*"
    },
  ]
}

variable "vmss_load_balancer_sku" {
  description = "The SKU of the Azure Load Balancer. Accepted values are Basic and Standard."
  default     = "Standard"
}

variable "vmss_load_balancer_health_probe_port" {
  description = "Port on which the Probe queries the backend endpoint. Default `80`"
  default     = 80
}

variable "vmss_load_balanced_port_list" {
  description = "List of ports to be forwarded through the load balancer to the VMs"
  type        = list(number)
  default     = [80, 443]
}

variable "vmss_scale_out_cpu_percentage_threshold" {
  description = "Specifies the threshold % of the metric that triggers the scale out action."
  default     = "80"
}

variable "vmss_scale_in_cpu_percentage_threshold" {
  description = "Specifies the threshold of the metric that triggers the scale in action."
  default     = "20"
}

variable "vmss_scaling_action_instances_number" {
  description = "The number of instances involved in the scaling action"
  default     = "1"
}