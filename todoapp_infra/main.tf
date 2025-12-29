module "rgs" {
  source = "../modules/ResourceGroup"
  rgs    = var.rgs
}

module "networking" {
  depends_on    = [module.rgs]
  source        = "../modules/Networking"
  vnets_subnets = var.vnets_subnets
  tags          = var.tags
}

module "vms" {
  depends_on      = [module.rgs, module.networking]
  source          = "../modules/LinuxVirtualMachine"
  vms             = var.vms
  vnet_subnet_ids = module.networking.vnet_subnet_ids
  tags            = var.tags
}

module "loadbalancers" {
  depends_on = [module.vms]
  source     = "../modules/LoadBalancer"

  loadbalancers = var.loadbalancers
  backend_pools = var.backend_pools
  nic_ids       = module.vms.vm_nic_ids
  tags          = var.tags
}

module "database" {
  depends_on  = [module.rgs]
  source      = "../modules/Database"
  sql_servers = var.sql_servers
  servers_dbs = var.servers_dbs
  # tags        = var.tags
}
