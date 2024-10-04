resource "azurerm_resource_group" "network" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = [var.vnet_cidr]
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name
}

resource "azurerm_subnet" "web" {
  name                 = var.subnet_web_name
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_web_cidr]
}

resource "azurerm_subnet" "app" {
  name                 = var.subnet_app_name
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_app_cidr]
}

resource "azurerm_subnet" "db" {
  name                 = var.subnet_db_name
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_db_cidr]
}

resource "azurerm_nat_gateway" "nat_gateway" {
  name                = "nat-gateway"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "Standard"

}

resource "azurerm_public_ip" "nat_public_ip" {
  name                = "nat-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_nat_gateway_public_ip_association" "nat_ip_association" {
  nat_gateway_id = azurerm_nat_gateway.nat_gateway.id
  public_ip_address_id   = azurerm_public_ip.nat_public_ip.id
}


resource "azurerm_subnet_nat_gateway_association" "app_nat_association" {
  subnet_id      = azurerm_subnet.app.id
  nat_gateway_id = azurerm_nat_gateway.nat_gateway.id
}

resource "azurerm_subnet_nat_gateway_association" "db_nat_association" {
  subnet_id      = azurerm_subnet.db.id
  nat_gateway_id = azurerm_nat_gateway.nat_gateway.id
}

resource "azurerm_route_table" "app_route_table" {
  name                = "app-tier-route-table"
  location            = var.location
  resource_group_name = var.resource_group_name

  route {
    name                   = "default-route"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "Internet"
    # next_hop_in_ip_address = azurerm_public_ip.nat_public_ip.ip_address
  }
}

resource "azurerm_route_table" "db_route_table" {
  name                = "db-tier-route-table"
  location            = var.location
  resource_group_name = var.resource_group_name

  route {
    name                   = "default-route"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "Internet"
    # next_hop_in_ip_address = azurerm_public_ip.nat_public_ip.ip_address
  }
}

resource "azurerm_subnet_route_table_association" "app_route_association" {
  subnet_id      = azurerm_subnet.app.id
  route_table_id = azurerm_route_table.app_route_table.id
}

resource "azurerm_subnet_route_table_association" "db_route_association" {
  subnet_id      = azurerm_subnet.db.id
  route_table_id = azurerm_route_table.db_route_table.id
}
