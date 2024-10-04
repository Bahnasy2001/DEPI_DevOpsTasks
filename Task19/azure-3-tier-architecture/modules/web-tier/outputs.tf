output "web_lb_public_ip" {
  description = "Public IP of the web-tier load balancer"
  value       = azurerm_public_ip.lb.ip_address
}

output "web_vm_private_ips" {
  description = "Private IPs of Web Tier VMs"
  value       = azurerm_network_interface.web_nic.*.private_ip_address
}

