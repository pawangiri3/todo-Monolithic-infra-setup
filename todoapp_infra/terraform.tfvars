# Resource Groups
rgs = {
  rg-todoapp = {
    location = "westus2"
  }
}

# Virtual Networks and Subnets
vnets_subnets = {
  vnet-todoapp = {
    location            = "westus2"
    resource_group_name = "rg-todoapp"
    address_space       = ["10.0.0.0/16"]
    enable_bastion      = false
    subnets = {
      frontend-subnet = {
        address_prefix = "10.0.0.0/24"
      }
      backend-subnet = {
        address_prefix = "10.0.1.0/24"
      }
    }
  }
}

# Virtual Machines
vms = {
  "frontendvm" = {
    resource_group_name = "rg-todoapp"
    location            = "westus2"
    vnet_name           = "vnet-todoapp"
    subnet_name         = "frontend-subnet"
    size                = "Standard_DS1_v2"
    admin_username      = "azureuser"
    admin_password      = "P@ssw01rd@123"
    userdata_script     = "install_nginx.sh"
    inbound_open_ports  = [22, 80]
    source_image_reference = {
      publisher = "Canonical"
      offer     = "0001-com-ubuntu-server-focal"
      sku       = "20_04-lts"
      version   = "latest"
    }
    enable_public_ip = true
  }
  "backendvm" = {
    resource_group_name = "rg-todoapp"
    location            = "westus2"
    vnet_name           = "vnet-todoapp"
    subnet_name         = "backend-subnet"
    size                = "Standard_DS1_v2"
    admin_username      = "azureuser"
    admin_password      = "P@ssw01rd@123"
    userdata_script     = "install_python.sh"
    inbound_open_ports  = [22, 8000]
    source_image_reference = {
      publisher = "Canonical"
      offer     = "0001-com-ubuntu-server-focal"
      sku       = "20_04-lts"
      version   = "latest"
    }
    enable_public_ip = false
  }
}

# Load Balancers
loadbalancers = {
  lb-todoapp = {
    location                       = "westus2"
    resource_group_name            = "rg-todoapp"
    frontend_ip_configuration_name = "PublicIPAddress"
    sku                            = "Standard"
  }
}

# Backend Pools
backend_pools = {
  frontend-pool = {
    port        = 80
    lb_name     = "lb-todoapp"
    backend_vms = ["frontendvm", "backendvm"]
  }
}

# SQL Servers
sql_servers = {
  "todoappserversrv1" = {
    name                    = "todoappserversrv1"
    resource_group_name     = "rg-todoapp"
    location                = "westus2"
    version                 = "12.0"
    administrator_login     = "sqladmin"
    administrator_password  = "P@ssw01rd@123"
    tags                    = { environment = "dev" }
  }
}

# Database Servers
servers_dbs = {
  "todoappdb" = {
    name         = "todoappdb"
    server       = "todoappserversrv1"
    collation    = "SQL_Latin1_General_CP1_CI_AS"
    license_type = "LicenseIncluded"
    max_size_gb  = "2"
    sku_name     = "Basic"
    tags         = { environment = "dev" }
  }
}

# Common Tags
tags = {
  environment = "dev"
  owner       = "devops"
}
