resource "azurerm_network_interface" "db_nic" {
  name                = "db-nic-${count.index}"
  location            = var.location
  resource_group_name = var.resource_group_name
  count               = var.db_vm_count

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.db_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "db_vm" {
  name                = "db-vm-${count.index}"
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = var.db_vm_size
  count               = var.db_vm_count
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [azurerm_network_interface.db_nic[count.index].id]
  disable_password_authentication = false
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
resource "azurerm_network_security_group" "db_nsg" {
  name                = "db-tier-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "allow-app-tier"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3306" # Example for MySQL; adjust for other DBs
    source_address_prefix      = var.app_subnet_address_prefix
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "db_nic_nsg_association" {
  count                     = var.db_vm_count
  network_interface_id       = azurerm_network_interface.db_nic[count.index].id
  network_security_group_id  = azurerm_network_security_group.db_nsg.id
}
