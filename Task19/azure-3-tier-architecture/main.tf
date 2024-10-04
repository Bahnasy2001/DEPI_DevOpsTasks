
# Configure the Microsoft Azure Provider
provider "azurerm" {
  subscription_id                 = "2876b6d2-2be8-44cb-8742-6acd23ed4f18"
  resource_provider_registrations = "none"
  features {}
}

module "networking" {
  source              = "./modules/networking"
  resource_group_name = "network"
  location            = "West Europe"
  vnet_name           = "my-vnet"
  vnet_cidr           = "10.0.0.0/16"
  subnet_web_name     = "web-subnet"
  subnet_web_cidr     = "10.0.1.0/24"
  subnet_app_name     = "app-subnet"
  subnet_app_cidr     = "10.0.2.0/24"
  subnet_db_name      = "db-subnet"
  subnet_db_cidr      = "10.0.3.0/24"
  nat_gateway_name    = "nat-gateway"
  web_subnet_address_prefix = "10.0.1.0/24"
  app_subnet_address_prefix = "10.0.2.0/24"
}

module "web-tier" {
  source              = "./modules/web-tier"
  resource_group_name = module.networking.resource_group_name
  location            = module.networking.location
  web_subnet_id       = module.networking.web_subnet_id
  web_vm_count        = 1
  web_vm_size         = "Standard_B2s"
  admin_username      = "adminuser"
  admin_password      = var.admin_password
}

module "app-tier" {
  source              = "./modules/app-tier"
  resource_group_name = module.networking.resource_group_name
  location            = module.networking.location
  app_subnet_id       = module.networking.app_subnet_id
  app_vm_count        = 1
  app_vm_size         = "Standard_B2s"
  admin_username      = "adminuser"
  admin_password      = var.admin_password
  web_subnet_address_prefix = module.networking.subnet_web_cidr
}

module "db-tier" {
  source              = "./modules/db-tier"
  resource_group_name = module.networking.resource_group_name
  location            = module.networking.location
  db_subnet_id        = module.networking.db_subnet_id
  db_vm_count         = 1
  db_vm_size          = "Standard_G1"
  admin_username      = "adminuser"
  admin_password      = var.admin_password
  app_subnet_address_prefix = module.networking.subnet_app_cidr
}
