output "db_vm_private_ips" {
  description = "Private IP addresses of the database-tier VMs"
  value       = azurerm_linux_virtual_machine.db_vm.*.private_ip_address
}
