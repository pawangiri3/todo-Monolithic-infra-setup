variable "vms" {
  description = "Linux VM configuration"
  type = map(object({
    resource_group_name = string
    location            = string
    size                = string

    admin_username = string
    admin_password = string

    vnet_name   = string
    subnet_name = string

    enable_public_ip = bool
    inbound_open_ports = list(number)

    source_image_reference = object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
    })

    userdata_script = optional(string)
  }))
}

variable "vnet_subnet_ids" {
  description = "VNET -> Subnet -> ID mapping"
  type        = map(map(string))
}

variable "tags" {
  description = "Common tags for resources"
  type        = map(string)
  default     = {}
}