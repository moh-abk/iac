data "null_data_source" "vmss_outputs" {
  inputs = {
    vmss_load_balancer_public_ip                     = azurerm_public_ip.pip.ip_address
    vmss_load_balancer_private_ip                    = azurerm_lb.vmsslb.private_ip_address
    vmss_load_balancer_nat_pool_id                   = azurerm_lb_nat_pool.natpol.id
    vmss_load_balancer_health_probe_id               = azurerm_lb_probe.lbp.id
    vmss_network_security_group_id                   = azurerm_network_security_group.nsg.id
    vmss_windows_virtual_machine_scale_set_name      = azurerm_windows_virtual_machine_scale_set.winsrv_vmss.name
    vmss_windows_virtual_machine_scale_set_id        = azurerm_windows_virtual_machine_scale_set.winsrv_vmss.id
    vmss_windows_virtual_machine_scale_set_unique_id = azurerm_windows_virtual_machine_scale_set.winsrv_vmss.unique_id
  }
}

output "vmss_result" {
  value = data.null_data_source.vmss_outputs.inputs
}

output "vmss_result_json" {
  value = jsonencode(data.null_data_source.vmss_outputs.inputs)
}
