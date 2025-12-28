variable "sql_servers" {
	description = "Map of SQL server objects keyed by identifier. Each object must include `name`, `resource_group_name`, `location` and `administrator_password`."
	type = map(object({
		name                    = string
		resource_group_name     = string
		location                = string
		version                 = string
		administrator_login     = string
		administrator_password  = string
		tags                    = optional(map(string))
	}))
	default = {}
}

variable "servers_dbs" {
	description = "Map of database objects keyed by identifier. Each object must include `name` and `server` (server key from var.sql_servers)."
	type = map(object({
		name         = string
		server       = string
		collation    = string
		license_type = string
		max_size_gb  = string
		sku_name     = string
		tags         = optional(map(string))
	}))
	default = {}
}
