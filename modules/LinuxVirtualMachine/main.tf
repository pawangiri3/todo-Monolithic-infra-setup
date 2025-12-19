############################
# PUBLIC IP (OPTIONAL)
############################

resource "azurerm_public_ip" "pips" {
  for_each = {
    for vm_name, vm in var.vms :
    vm_name => vm if vm.enable_public_ip
  }

  name                = "${each.key}-pip"
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = var.tags
}

############################
# NETWORK INTERFACE
############################

resource "azurerm_network_interface" "nic" {
  for_each            = var.vms
  name                = "${each.key}-nic"
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.vnet_subnet_ids[each.value.vnet_name][each.value.subnet_name]
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = try(azurerm_public_ip.pips[each.key].id, null)
  }

  tags = var.tags
}

############################
# NETWORK SECURITY GROUP
############################

resource "azurerm_network_security_group" "nsg" {
  for_each            = var.vms
  name                = "${each.key}-nsg"
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  dynamic "security_rule" {
    for_each = each.value.inbound_open_ports
    content {
      name                       = "Allow-${security_rule.value}"
      priority                   = 100 + security_rule.key
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = security_rule.value
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }

  tags = var.tags
}

resource "azurerm_network_interface_security_group_association" "nsg_assoc" {
  for_each                  = var.vms
  network_interface_id      = azurerm_network_interface.nic[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg[each.key].id
}

############################
# LINUX VM
############################

resource "azurerm_linux_virtual_machine" "vms" {
  for_each                        = var.vms
  name                            = each.key
  resource_group_name             = each.value.resource_group_name
  location                        = each.value.location
  size                            = each.value.size

  admin_username                  = each.value.admin_username
  admin_password                  = each.value.admin_password
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.nic[each.key].id
  ]

  custom_data = each.value.userdata_script != null ? base64encode(file("${path.root}/../scripts/${each.value.userdata_script}")) : null

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = each.value.source_image_reference.publisher
    offer     = each.value.source_image_reference.offer
    sku       = each.value.source_image_reference.sku
    version   = each.value.source_image_reference.version
  }

  tags = var.tags
}

############################
# OUTPUTS
############################

output "vm_ids" {
  value = { for k, v in azurerm_linux_virtual_machine.vms : k => v.id }
}

output "vm_private_ips" {
  value = { for k, v in azurerm_linux_virtual_machine.vms : k => v.private_ip_address }
}

output "vm_public_ips" {
  value = { for k, v in azurerm_linux_virtual_machine.vms : k => v.public_ip_address }
}

output "vm_nic_ids" {
  value = { for k, v in azurerm_linux_virtual_machine.vms : k => v.network_interface_ids[0] }
}
