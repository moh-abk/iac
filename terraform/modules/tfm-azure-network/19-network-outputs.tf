data "null_data_source" "network_outputs" {
  inputs = {
    network_shortname      = var.network_shortname
    network_location       = azurerm_virtual_network.virtual_network.location
    network_id             = azurerm_virtual_network.virtual_network.id
    network_dns_zone_name  = azurerm_dns_zone.dns_zone.name
    network_name           = azurerm_virtual_network.virtual_network.name
    network_resource_group = azurerm_virtual_network.virtual_network.resource_group_name
    network_address_space  = join(",", azurerm_virtual_network.virtual_network.address_space)
  }
}
