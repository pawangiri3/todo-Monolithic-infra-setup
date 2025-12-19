############################
# PUBLIC IP
############################

resource "azurerm_public_ip" "pip" {
  for_each            = var.loadbalancers
  name                = "${each.key}-lb-pip"
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  allocation_method   = "Static"
  sku                 = each.value.sku

  tags = var.tags
}

############################
# LOAD BALANCER
############################

resource "azurerm_lb" "lb" {
  for_each            = var.loadbalancers
  name                = each.key
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  sku                 = each.value.sku

  frontend_ip_configuration {
    name                 = each.value.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.pip[each.key].id
  }

  tags = var.tags
}

############################
# BACKEND ADDRESS POOLS
############################

resource "azurerm_lb_backend_address_pool" "backend_pool" {
  for_each        = var.backend_pools
  name            = each.key
  loadbalancer_id = azurerm_lb.lb[each.value.lb_name].id
}

############################
# NIC → BACKEND POOL ASSOCIATION
############################

locals {
  backend_vm_map = flatten([
    for pool_name, pool in var.backend_pools : [
      for vm in pool.backend_vms : {
        pool = pool_name
        vm   = vm
      }
    ]
  ])
}

resource "azurerm_network_interface_backend_address_pool_association" "bapa" {
  for_each = {
    for item in local.backend_vm_map :
    "${item.pool}-${item.vm}" => item
  }

  network_interface_id    = var.nic_ids[each.value.vm]
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend_pool[each.value.pool].id
}

############################
# HEALTH PROBES
############################

resource "azurerm_lb_probe" "probe" {
  for_each        = var.backend_pools
  name            = "${each.key}-probe"
  loadbalancer_id = azurerm_lb.lb[each.value.lb_name].id
  port            = each.value.port
  protocol        = "Tcp"
}

############################
# LOAD BALANCER RULES
############################

resource "azurerm_lb_rule" "rule" {
  for_each                       = var.backend_pools
  name                           = "${each.key}-rule"
  loadbalancer_id                = azurerm_lb.lb[each.value.lb_name].id
  protocol                       = "Tcp"
  frontend_port                  = each.value.port
  backend_port                   = each.value.port
  frontend_ip_configuration_name = var.loadbalancers[each.value.lb_name].frontend_ip_configuration_name
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.backend_pool[each.key].id]
  probe_id                       = azurerm_lb_probe.probe[each.key].id
}

############################
# OUTPUTS
############################

output "loadbalancer_public_ips" {
  value = {
    for k, v in azurerm_public_ip.pip :
    k => v.ip_address
  }
}
