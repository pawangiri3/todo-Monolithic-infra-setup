variable "vnets_subnets" {
  description = "Virtual networks and subnets configuration"
  type        = any
}

variable "rgs" {
  description = "Resource groups configuration"
  type        = any
}

variable "vms" {
  description = "Virtual machines configuration"
  type        = any
}

variable "loadbalancers" {
  description = "Load balancers configuration"
  type        = any
  default     = {}
}

variable "backend_pools" {
  description = "Backend pools configuration"
  type        = any
  default     = {}
}

variable "servers_dbs" {
  description = "Database servers configuration"
  type        = any
}

variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    environment = "dev"
    owner       = "devops"
  }
}
