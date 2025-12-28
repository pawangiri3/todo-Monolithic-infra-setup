############################
# SQL SERVERS
############################

resource "azurerm_mssql_server" "this" {
  for_each = var.sql_servers

  name                         = each.value.name
  resource_group_name          = each.value.resource_group_name
  location                     = each.value.location
  version                      = each.value.version
  administrator_login          = each.value.administrator_login
  administrator_login_password = each.value.administrator_password

  tags = each.value.tags
}

############################
# SQL DB
############################

resource "azurerm_mssql_database" "this" {
  for_each = var.servers_dbs

  name      = each.value.name
  server_id = azurerm_mssql_server.this[each.value.server].id

  collation    = each.value.collation
  license_type = each.value.license_type
  max_size_gb  = each.value.max_size_gb
  sku_name     = each.value.sku_name

  tags = try(each.value.tags, {})


}

############################
# OUTPUTS
############################

output "sql_servers" {
  description = "Map of server keys to fully qualified domain names"
  value = {
    for k, v in azurerm_mssql_server.this :
    k => v.fully_qualified_domain_name
  }
}

output "databases" {
  description = "Map of database keys to details"
  value = {
    for k, v in azurerm_mssql_database.this :
    k => {
      id        = v.id
      name      = v.name
      server_id = v.server_id
    }
  }
}