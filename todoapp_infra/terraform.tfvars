# Resource Groups
rgs = {
  rg-todoapp = {
    location = "eastus"
  }
}

# Virtual Networks and Subnets
vnets_subnets = {
  vnet-todoapp = {
    location            = "eastus"
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
    location            = "eastus"
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
    location            = "eastus"
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
    location                       = "eastus"
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

# Database Servers
servers_dbs = {
  "devopsinssrv1" = {
    resource_group_name     = "rg-todoapp"
    location                = "eastus"
    aad_admin_name          = "sql-admins"
    aad_admin_object_id     = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    dbs                     = ["todoappdb"]
    create_private_endpoint = false
  }
}

# Common Tags
tags = {
  environment = "dev"
  owner       = "devops"
}
