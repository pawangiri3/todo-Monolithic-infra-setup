############################
# VIRTUAL NETWORKS
############################

resource "azurerm_virtual_network" "vnets" {
  for_each            = var.vnets_subnets
  name                = each.key
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  address_space       = each.value.address_space

  tags = var.tags
}

############################
# SUBNETS (BEST PRACTICE)
############################

locals {
  subnet_map = flatten([
    for vnet_name, vnet in var.vnets_subnets : [
      for subnet_name, subnet in vnet.subnets : {
        vnet_name  = vnet_name
        subnet     = subnet_name
        cidr       = subnet.address_prefix
        rg         = vnet.resource_group_name
      }
    ]
  ])
}

resource "azurerm_subnet" "subnets" {
  for_each = {
    for s in local.subnet_map :
    "${s.vnet_name}-${s.subnet}" => s
  }

  name                 = each.value.subnet
  resource_group_name  = each.value.rg
  virtual_network_name = each.value.vnet_name
  address_prefixes     = [each.value.cidr]
}

############################
# SUBNET OUTPUT MAP
############################

output "vnet_subnet_ids" {
  value = {
    for vnet_name in keys(var.vnets_subnets) :
    vnet_name => {
      for s in azurerm_subnet.subnets :
      s.name => s.id
      if s.virtual_network_name == vnet_name
    }
  }
}

############################
# BASTION PUBLIC IP (OPTIONAL)
############################

resource "azurerm_public_ip" "bastion_pip" {
  for_each = {
    for k, v in var.vnets_subnets :
    k => v if v.enable_bastion == true
  }

  name                = "${each.key}-bastion-pip"
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = var.tags
}

############################
# BASTION HOST
############################

resource "azurerm_bastion_host" "bastion" {
  for_each = {
    for k, v in var.vnets_subnets :
    k => v if v.enable_bastion == true
  }

  name                = "${each.key}-bastion"
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.subnets["${each.key}-AzureBastionSubnet"].id
    public_ip_address_id = azurerm_public_ip.bastion_pip[each.key].id
  }

  tags = var.tags
}
