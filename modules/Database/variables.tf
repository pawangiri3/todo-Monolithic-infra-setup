
data "azurerm_client_config" "current" {}

############################
# VARIABLES
############################

variable "servers_dbs" {
  description = "SQL servers and databases configuration"
  type = map(object({
    resource_group_name = string
    location            = string

    aad_admin_name      = string
    aad_admin_object_id = string

    dbs = list(string)

    create_private_endpoint = optional(bool, false)
    subnet_id               = optional(string)
  }))
}

variable "tags" {
  type    = map(string)
  default = {}
}

############################
# LOCALS
############################

locals {
  databases = flatten([
    for server_name, server in var.servers_dbs : [
      for db in server.dbs : {
        server = server_name
        name   = db
      }
    ]
  ])
}
