#--------------------------------------------------------------
# Connectivity
#--------------------------------------------------------------

# Subnets

## DMZ (VPN)

resource "azurerm_subnet" "dmz_subnet" {
  address_prefixes = [var.dmz_subnet_cidr_blocks]

  name = format("%s_dmz_%s",
    lookup(data.null_data_source.network_defaults.inputs, "name_prefix"),
    var.deploy_environment
  )

  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
}

## Public

resource "azurerm_subnet" "public_subnet" {
  address_prefixes = [var.public_subnet_cidr_blocks]

  name = format("%s_public_%s",
    lookup(data.null_data_source.network_defaults.inputs, "name_prefix"),
    var.deploy_environment
  )

  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
}

## Private

resource "azurerm_subnet" "private_subnet" {
  address_prefixes = [var.private_subnet_cidr_blocks]

  name = format("%s_private_%s",
    lookup(data.null_data_source.network_defaults.inputs, "name_prefix"),
    var.deploy_environment
  )

  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
}

## Application Gateway

resource "azurerm_subnet" "application_gateway_subnet" {
  address_prefixes = [var.application_gateway_subnet_cidr_blocks]

  name = format("%s_application_gateway_%s",
    lookup(data.null_data_source.network_defaults.inputs, "name_prefix"),
    var.deploy_environment
  )

  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
}

# Route Table

resource "azurerm_route_table" "route_table" {
  name = format("%s_route_table_%s",
    lookup(data.null_data_source.network_defaults.inputs, "name_prefix"),
    var.deploy_environment
  )

  location            = var.network_location
  resource_group_name = var.resource_group_name

  route {
    name                   = "default"
    address_prefix         = "10.100.0.0/14"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.10.1.1"
  }
}
