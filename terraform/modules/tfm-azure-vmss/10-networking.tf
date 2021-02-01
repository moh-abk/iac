#-----------------------------------
# Windows VMSS Networking
#-----------------------------------

resource "azurerm_public_ip" "pip" {
  name                = lower("pip-vm-${var.service_shortname}-${replace(var.network_location, " ", "-")}")
  location            = var.network_location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = format("vm%spip", lower(replace(var.service_shortname, "/[[:^alnum:]]/", "")))
  tags = merge(
    data.null_data_source.tag_defaults.inputs,
    map(
      "Name", replace(
        format("%s-%s-lb-pip",
          var.service_name_prefix,
          lookup(data.null_data_source.tag_defaults.inputs, "Environment")
        ),
        "_",
        "-"
      )
    )
  )
}

resource "azurerm_lb" "vmsslb" {
  name                = lower("lbext-${var.service_shortname}-${replace(var.network_location, " ", "-")}")
  location            = var.network_location
  resource_group_name = var.resource_group_name
  sku                 = var.vmss_load_balancer_sku

  frontend_ip_configuration {
    name                 = lower("lbext-frontend-${var.service_shortname}")
    public_ip_address_id = azurerm_public_ip.pip.id
  }

  tags = merge(
    data.null_data_source.tag_defaults.inputs,
    map(
      "Name", replace(
        format("%s-%s-lbext",
          var.service_name_prefix,
          lookup(data.null_data_source.tag_defaults.inputs, "Environment")
        ),
        "_",
        "-"
      )
    )
  )
}

resource "azurerm_lb_backend_address_pool" "bepool" {
  name                = lower("lbe-backend-pool-${var.service_shortname}")
  resource_group_name = var.resource_group_name
  loadbalancer_id     = azurerm_lb.vmsslb.id
}

resource "azurerm_lb_nat_pool" "natpol" {
  name                           = lower("lbe-nat-pool-${var.service_shortname}-${replace(var.network_location, " ", "-")}")
  resource_group_name            = var.resource_group_name
  loadbalancer_id                = azurerm_lb.vmsslb.id
  protocol                       = "Tcp"
  frontend_port_start            = var.vmss_nat_pool_frontend_ports[0]
  frontend_port_end              = var.vmss_nat_pool_frontend_ports[1]
  backend_port                   = 3389
  frontend_ip_configuration_name = azurerm_lb.vmsslb.frontend_ip_configuration.0.name
}

resource "azurerm_lb_probe" "lbp" {
  name                = lower("lb-probe-port-${var.vmss_load_balancer_health_probe_port}-${var.service_shortname}")
  resource_group_name = var.resource_group_name
  loadbalancer_id     = azurerm_lb.vmsslb.id
  port                = var.vmss_load_balancer_health_probe_port
}

resource "azurerm_lb_rule" "lbrule" {
  count                          = length(var.vmss_load_balanced_port_list)
  name                           = format("%s-%02d-rule", var.service_shortname, count.index + 1)
  resource_group_name            = var.resource_group_name
  loadbalancer_id                = azurerm_lb.vmsslb.id
  probe_id                       = azurerm_lb_probe.lbp.id
  protocol                       = "Tcp"
  frontend_port                  = tostring(var.vmss_load_balanced_port_list[count.index])
  backend_port                   = tostring(var.vmss_load_balanced_port_list[count.index])
  frontend_ip_configuration_name = azurerm_lb.vmsslb.frontend_ip_configuration.0.name
  backend_address_pool_id        = azurerm_lb_backend_address_pool.bepool.id
}

resource "azurerm_network_security_group" "nsg" {
  name                = lower("nsg_${var.service_shortname}_${replace(var.network_location, " ", "-")}_in")
  resource_group_name = var.resource_group_name
  location            = var.network_location
  tags = merge(
    data.null_data_source.tag_defaults.inputs,
    map(
      "Name", replace(
        format("%s-%s-nsg",
          var.service_name_prefix,
          lookup(data.null_data_source.tag_defaults.inputs, "Environment")
        ),
        "_",
        "-"
      )
    )
  )
}

resource "azurerm_network_security_rule" "nsg_rule" {
  for_each                    = local.nsg_inbound_rules
  name                        = each.key
  priority                    = 100 * (each.value.idx + 1)
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = each.value.security_rule.destination_port_range
  source_address_prefix       = each.value.security_rule.source_address_prefix
  destination_address_prefix  = element(concat(data.azurerm_subnet.public.address_prefixes, [""]), 0)
  description                 = "Inbound_Port_${each.value.security_rule.destination_port_range}"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg.name
  depends_on                  = [azurerm_network_security_group.nsg]
}