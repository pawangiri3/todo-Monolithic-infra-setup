variable "vnets_subnets" {
  description = "VNETs with subnets and optional Bastion"
  type = map(object({
    resource_group_name = string
    location            = string
    address_space       = list(string)

    enable_bastion = optional(bool, false)

    subnets = map(object({
      address_prefix = string
    }))
  }))
}

variable "tags" {
  type    = map(string)
  default = {}
}
