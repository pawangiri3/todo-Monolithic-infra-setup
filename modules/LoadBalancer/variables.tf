variable "loadbalancers" {
  description = "Azure Load Balancers"
  type = map(object({
    resource_group_name = string
    location            = string
    sku                 = string

    frontend_ip_configuration_name = string
  }))
}

variable "backend_pools" {
  description = "Backend pool definitions"
  type = map(object({
    lb_name     = string
    port        = number
    backend_vms = list(string) # VM names (keys from nic_ids)
  }))
}

variable "nic_ids" {
  description = "VM NIC IDs"
  type        = map(string)
}

variable "tags" {
  type    = map(string)
  default = {}
}
