rgs = {
  rg-devopsinsiders = {
    location = "West Europe"
  }
}

vnets_subnets = {
  vnet-devopsinsiders = {
    location            = "West Europe"
    resource_group_name = "rg-devopsinsiders"
    address_space       = ["10.0.0.0/16"]
    # The AzureBastionSubnet Block is required in subnets if enable_bastion=true 
    # AzureBastionSubnet = {
    #     address_prefix = "10.0.2.0/24"
    # }
    enable_bastion = false
    subnets = {
      frontend-subnet = {
        address_prefix = "10.0.0.0/24"
      }
      backend-subnet = {
        address_prefix = "10.0.1.0/24"
      }
      # AzureBastionSubnet = {
      #   address_prefix = "10.0.2.0/24"
      # }
    }
  }
}

vms = {
  "frontendvm" = {
    resource_group_name = "rg-devopsinsiders"
    location            = "West Europe"
    vnet_name           = "vnet-devopsinsiders"
    subnet_name         = "frontend-subnet"
    size                = "Standard_DS1_v2"
    admin_username      = "devopsadmin"
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
    resource_group_name = "rg-devopsinsiders"
    location            = "West Europe"
    vnet_name           = "vnet-devopsinsiders"
    subnet_name         = "backend-subnet"
    size                = "Standard_DS1_v2"
    admin_username      = "devopsadmin"
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

loadbalancers = {
  lb-devopsinsiders = {
    location                       = "West Europe"
    resource_group_name            = "rg-devopsinsiders"
    frontend_ip_configuration_name = "PublicIPAddress"
    sku                            = "Standard"
  }
}

backend_pools = {
  frontend-pool = {
    port        = 80
    lb_name     = "lb-devopsinsiders"
    backend_vms = ["frontendvm1", "frontendvm2"]
  }
}

servers_dbs = {
  "devopsinssrv1" = {
    resource_group_name            = "rg-devopsinsiders"
    location                       = "West Europe"
    version                        = "12.0"
    administrator_login            = "devopsadmin"
    administrator_login_password   = "P@ssw01rd@123"
    allow_access_to_azure_services = true
    dbs                            = ["todoappdb"]
  }
}



vnet_subnet_ids = {
  vnet-main = {
    subnet-app = "/subscriptions/xxx/resourceGroups/rg-net/providers/Microsoft.Network/virtualNetworks/vnet-main/subnets/subnet-app"
  }
}

vms = {
  vm-app-01 = {
    resource_group_name = "rg-app"
    location            = "Central India"
    size                = "Standard_B2ms"

    admin_username = "azureuser"
    admin_password = "ChangeMe@123"

    vnet_name   = "vnet-main"
    subnet_name = "subnet-app"

    enable_public_ip     = true
    inbound_open_ports   = [22, 80]

    source_image_reference = {
      publisher = "Canonical"
      offer     = "0001-com-ubuntu-server-jammy"
      sku       = "22_04-lts"
      version   = "latest"
    }

    userdata_script = "init.sh"
  }
}

tags = {
  environment = "dev"
  owner       = "devops"
}




servers_dbs = {
  sql-dev-01 = {
    resource_group_name = "rg-dev"
    location            = "Central India"

    aad_admin_name      = "sql-admins"
    aad_admin_object_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

    dbs = ["appdb", "authdb"]

    create_private_endpoint = true
    subnet_id               = "/subscriptions/xxx/resourceGroups/rg-net/providers/Microsoft.Network/virtualNetworks/vnet1/subnets/private"
  }
}

tags = {
  environment = "dev"
  owner       = "devops"
}


loadbalancers = {
  app-lb = {
    resource_group_name = "rg-app"
    location            = "Central India"
    sku                 = "Standard"
    frontend_ip_configuration_name = "app-fe"
  }
}

backend_pools = {
  web-pool = {
    lb_name     = "app-lb"
    port        = 80
    backend_vms = ["vm-app-01", "vm-app-02"]
  }
}

nic_ids = {
  vm-app-01 = "/subscriptions/xxx/.../networkInterfaces/vm-app-01-nic"
  vm-app-02 = "/subscriptions/xxx/.../networkInterfaces/vm-app-02-nic"
}

tags = {
  environment = "dev"
  owner       = "devops"
}


vnets_subnets = {
  vnet-main = {
    resource_group_name = "rg-net"
    location            = "Central India"
    address_space       = ["10.0.0.0/16"]
    enable_bastion      = true

    subnets = {
      AzureBastionSubnet = {
        address_prefix = "10.0.0.0/26"
      }
      subnet-app = {
        address_prefix = "10.0.1.0/24"
      }
      subnet-db = {
        address_prefix = "10.0.2.0/24"
      }
    }
  }
}

tags = {
  environment = "dev"
  owner       = "devops"
}
