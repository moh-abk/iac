data "null_data_source" "connectivity_outputs" {
  inputs = {
    dmz_subnet_id                                   = azurerm_subnet.dmz_subnet.id
    dmz_subnet_name                                 = azurerm_subnet.dmz_subnet.name
    dmz_subnet_resource_group_name                  = azurerm_subnet.dmz_subnet.resource_group_name
    dmz_subnet_virtual_network_name                 = azurerm_subnet.dmz_subnet.virtual_network_name
    dmz_subnet_address_prefix                       = azurerm_subnet.dmz_subnet.address_prefix
    public_subnet_id                                = azurerm_subnet.public_subnet.id
    public_subnet_name                              = azurerm_subnet.public_subnet.name
    public_subnet_resource_group_name               = azurerm_subnet.public_subnet.resource_group_name
    public_subnet_virtual_network_name              = azurerm_subnet.public_subnet.virtual_network_name
    public_subnet_address_prefix                    = azurerm_subnet.public_subnet.address_prefix
    private_subnet_id                               = azurerm_subnet.private_subnet.id
    private_subnet_name                             = azurerm_subnet.private_subnet.name
    private_subnet_resource_group_name              = azurerm_subnet.private_subnet.resource_group_name
    private_subnet_virtual_network_name             = azurerm_subnet.private_subnet.virtual_network_name
    private_subnet_address_prefix                   = azurerm_subnet.private_subnet.address_prefix
    application_gateway_subnet_id                   = azurerm_subnet.application_gateway_subnet.id
    application_gateway_subnet_name                 = azurerm_subnet.application_gateway_subnet.name
    application_gateway_subnet_resource_group_name  = azurerm_subnet.application_gateway_subnet.resource_group_name
    application_gateway_subnet_virtual_network_name = azurerm_subnet.application_gateway_subnet.virtual_network_name
    application_gateway_subnet_address_prefix       = azurerm_subnet.application_gateway_subnet.address_prefix
  }
}
