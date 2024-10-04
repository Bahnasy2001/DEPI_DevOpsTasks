output "vnet_id" {
  description = "ID of the virtual network"
  value       = azurerm_virtual_network.vnet.id
}

output "web_subnet_id" {
  description = "ID of the web subnet"
  value       = azurerm_subnet.web.id
}

output "app_subnet_id" {
  description = "ID of the app subnet"
  value       = azurerm_subnet.app.id
}

output "db_subnet_id" {
  description = "ID of the database subnet"
  value       = azurerm_subnet.db.id
}
output "resource_group_name" {
  value = azurerm_resource_group.network.name
}

output "location" {
  value = azurerm_resource_group.network.location
}

output "subnet_web_cidr" {
  value = azurerm_subnet.web.address_prefixes[0]
}

output "subnet_app_cidr" {
  value = azurerm_subnet.app.address_prefixes[0]
}

output "subnet_db_cidr" {
  value = azurerm_subnet.db.address_prefixes[0]
}

