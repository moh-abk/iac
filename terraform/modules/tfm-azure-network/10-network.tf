#--------------------------------------------------------------
# Network
#--------------------------------------------------------------

resource "azurerm_virtual_network" "virtual_network" {
  address_space = [
    var.network_address_space,
  ]

  location = var.network_location

  name = format("%s_%s_network",
    lookup(data.null_data_source.network_defaults.inputs, "name_prefix"),
    lookup(data.null_data_source.tag_defaults.inputs, "Environment")
  )

  resource_group_name = var.resource_group_name

  tags = merge(
    data.null_data_source.tag_defaults.inputs,
    map(
      "Name", format("%s_%s_network",
        lookup(data.null_data_source.network_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
      )
    )
  )
}

resource "azurerm_dns_zone" "dns_zone" {
  name = lookup(
    data.null_data_source.network_defaults.inputs, "network_internal_zonename"
  )

  resource_group_name = var.resource_group_name

  tags = merge(
    data.null_data_source.tag_defaults.inputs,
    map(
      "Name", format("%s_%s_network",
        lookup(data.null_data_source.network_defaults.inputs, "name_prefix"),
        lookup(data.null_data_source.tag_defaults.inputs, "Environment")
      )
    )
  )
}
