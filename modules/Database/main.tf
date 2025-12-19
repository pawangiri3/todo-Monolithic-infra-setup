############################
# SQL SERVERS
############################

resource "azurerm_mssql_server" "servers" {
  for_each            = var.servers_dbs
  name                = each.key
  resource_group_name = each.value.resource_group_name
  location            = each.value.location

  version                      = "12.0"
  public_network_access_enabled = false
  minimum_tls_version           = "1.2"

  tags = var.tags
}

############################
# AZURE AD ADMIN
############################

resource "azurerm_mssql_server_active_directory_administrator" "aad_admin" {
  for_each  = var.servers_dbs
  server_id = azurerm_mssql_server.servers[each.key].id

  login     = each.value.aad_admin_name
  object_id = each.value.aad_admin_object_id
  tenant_id = data.azurerm_client_config.current.tenant_id
}

############################
# SQL DATABASES
############################

resource "azurerm_mssql_database" "dbs" {
  for_each = {
    for db in local.databases :
    "${db.server}-${db.name}" => db
  }

  name      = each.value.name
  server_id = azurerm_mssql_server.servers[each.value.server].id

  sku_name = "Basic"
  zone_redundant = false
}


############################
# OUTPUTS (SAFE)
############################

output "sql_servers" {
  value = {
    for k, v in azurerm_mssql_server.servers :
    k => v.fully_qualified_domain_name
  }
}

output "databases" {
  value = [
    for db in local.databases :
    "${db.server}/${db.name}"
  ]
}