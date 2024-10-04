resource "azurerm_network_interface" "app_nic" {
  name                = "app-nic-${count.index}"
  location            = var.location
  resource_group_name = var.resource_group_name
  count               = var.app_vm_count

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.app_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "app_vm" {
  name                = "app-vm-${count.index}"
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = var.app_vm_size
  count               = var.app_vm_count
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [azurerm_network_interface.app_nic[count.index].id]
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
resource "azurerm_network_security_group" "app_nsg" {
  name                = "app-tier-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "allow-web-tier"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = var.web_subnet_address_prefix
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-internet-outbound"
    priority                   = 200
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  }
}

resource "azurerm_network_interface_security_group_association" "app_nic_nsg_association" {
  count                     = var.app_vm_count
  network_interface_id       = azurerm_network_interface.app_nic[count.index].id
  network_security_group_id  = azurerm_network_security_group.app_nsg.id
}
