resource "azurerm_public_ip" "lb" {
  name                = "web-lb-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
}

resource "azurerm_lb" "web_lb" {
  name                = "web-tier-lb"
  location            = var.location
  resource_group_name = var.resource_group_name
  frontend_ip_configuration {
    name                 = "frontend"
    public_ip_address_id = azurerm_public_ip.lb.id
  }
}

resource "azurerm_lb_backend_address_pool" "bepool" {
  loadbalancer_id = azurerm_lb.web_lb.id
  name            = "web-backend-pool"
}

resource "azurerm_network_interface" "web_nic" {
  name                = "web-nic-${count.index}"
  location            = var.location
  resource_group_name = var.resource_group_name
  count               = var.web_vm_count

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.web_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_backend_address_pool_association" "nic_lb_association" {
  ip_configuration_name       = "internal"  # The name from the ip_configuration block
  count                      = var.web_vm_count
  network_interface_id        = azurerm_network_interface.web_nic[count.index].id
  backend_address_pool_id     = azurerm_lb_backend_address_pool.bepool.id
}
resource "azurerm_linux_virtual_machine" "web_vm" {
  name                = "web-vm-${count.index}"
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = var.web_vm_size
  count               = var.web_vm_count
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [azurerm_network_interface.web_nic[count.index].id]
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
resource "azurerm_network_security_group" "web_nsg" {
  name                = "web-tier-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "allow-http"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-https"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  
}

resource "azurerm_network_interface_security_group_association" "web_nic_nsg_association" {
  count                     = var.web_vm_count
  network_interface_id       = azurerm_network_interface.web_nic[count.index].id
  network_security_group_id  = azurerm_network_security_group.web_nsg.id
}


resource "azurerm_lb_probe" "http_health_probe" {
  name                = "http-health-probe"
  loadbalancer_id     = azurerm_lb.web_lb.id
  protocol            = "Http"
  port                = 80
  request_path        = "/"
  interval_in_seconds = 5
  number_of_probes    = 2
}

resource "azurerm_lb_rule" "http_lb_rule" {
  name                         = "http-lb-rule"
  loadbalancer_id              = azurerm_lb.web_lb.id
  frontend_ip_configuration_name = azurerm_lb.web_lb.frontend_ip_configuration[0].name
  protocol                     = "Tcp"
  frontend_port                = 80
  backend_port                 = 80
  enable_floating_ip           = false
  idle_timeout_in_minutes      = 5
  load_distribution            = "Default"
  
  probe_id                     = azurerm_lb_probe.http_health_probe.id
}
