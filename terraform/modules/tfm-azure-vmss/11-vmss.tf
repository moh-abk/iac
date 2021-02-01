#---------------------------------------
# Windows VMSS
#---------------------------------------

resource "azurerm_windows_virtual_machine_scale_set" "winsrv_vmss" {
  name                   = format("%s", lower(replace(var.service_shortname, "/[[:^alnum:]]/", "")))
  computer_name_prefix   = format("%s", lower(replace(var.service_name_prefix, "/[[:^alnum:]]/", "")))
  resource_group_name    = var.resource_group_name
  location               = var.network_location
  overprovision          = var.vmss_overprovision
  sku                    = var.vmss_virtual_machine_size
  instances              = var.vmss_instances_count
  zones                  = var.vmss_availability_zones
  zone_balance           = var.vmss_availability_zone_balance
  single_placement_group = var.vmss_single_placement_group
  admin_username         = var.vmss_admin_username
  admin_password         = var.vmss_admin_password
  source_image_id        = var.vmss_source_image_id
  upgrade_mode           = var.vmss_os_upgrade_mode
  health_probe_id        = azurerm_lb_probe.lbp.id
  provision_vm_agent     = true
  license_type           = var.vmss_license_type

  os_disk {
    storage_account_type = var.vmss_os_disk_storage_account_type
    caching              = "ReadWrite"
  }

  network_interface {
    name                          = lower("nic-${format("vm%s", lower(replace(var.service_shortname, "/[[:^alnum:]]/", "")))}")
    primary                       = true
    enable_ip_forwarding          = var.vmss_enable_ip_forwarding
    enable_accelerated_networking = var.vmss_enable_accelerated_networking
    network_security_group_id     = azurerm_network_security_group.nsg.id

    ip_configuration {
      name                                   = lower("ipconig-${format("vm%s", lower(replace(var.service_shortname, "/[[:^alnum:]]/", "")))}")
      primary                                = true
      subnet_id                              = data.azurerm_subnet.public.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.bepool.id]
      load_balancer_inbound_nat_rules_ids    = [azurerm_lb_nat_pool.natpol.id]

      dynamic "public_ip_address" {
        for_each = var.vmss_assign_public_ip_to_each_vm_in_vmss ? [{}] : []
        content {
          name              = lower("pip-${format("vm%s", lower(replace(var.service_shortname, "/[[:^alnum:]]/", "")))}")
          domain_name_label = format("vm-%s%s-pip0${count.index + 1}", lower(replace(var.service_shortname, "/[[:^alnum:]]/", "")))
        }
      }
    }
  }

  automatic_instance_repair {
    enabled      = var.vmss_enable_automatic_instance_repair
    grace_period = var.vmss_grace_period
  }

  tags = merge(
    data.null_data_source.tag_defaults.inputs,
    map(
      "Name", replace(
        format("%s-%s-server",
          var.service_name_prefix,
          lookup(data.null_data_source.tag_defaults.inputs, "Environment")
        ),
        "_",
        "-"
      )
    )
  )

  depends_on = [azurerm_lb_rule.lbrule]
}

resource "azurerm_monitor_autoscale_setting" "auto" {
  name                = lower("auto-scale-set-${var.service_shortname}")
  resource_group_name = var.resource_group_name
  location            = var.network_location
  target_resource_id  = azurerm_windows_virtual_machine_scale_set.winsrv_vmss.id

  profile {
    name = "default"
    capacity {
      default = var.vmss_instances_count
      minimum = var.vmss_minimum_instances_count == null ? var.vmss_instances_count : var.vmss_minimum_instances_count
      maximum = var.vmss_maximum_instances_count
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_windows_virtual_machine_scale_set.winsrv_vmss.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = var.vmss_scale_out_cpu_percentage_threshold
      }
      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = var.vmss_scaling_action_instances_number
        cooldown  = "PT1M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_windows_virtual_machine_scale_set.winsrv_vmss.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = var.vmss_scale_in_cpu_percentage_threshold
      }
      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = var.vmss_scaling_action_instances_number
        cooldown  = "PT1M"
      }
    }
  }
}