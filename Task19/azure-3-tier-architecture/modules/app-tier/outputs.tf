output "app_vm_private_ips" {
  description = "Private IP addresses of the application-tier VMs"
  value       = azurerm_linux_virtual_machine.app_vm.*.private_ip_address
}
