output "web_vm_private_ips" {
  description = "Private IPs of Web Tier VMs"
  value       = module.web-tier.web_vm_private_ips
}

output "app_vm_private_ips" {
  description = "Private IPs of App Tier VMs"
  value       = module.app-tier.app_vm_private_ips
}

output "db_vm_private_ips" {
  description = "Private IPs of DB Tier VMs"
  value       = module.db-tier.db_vm_private_ips
}
