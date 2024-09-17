# Output for Web Tier Private IPs
output "web_private_ips" {
  value = data.aws_instances.web_instances.private_ips
}

# Output for App Tier Private IPs
output "app_private_ips" {
  value = data.aws_instances.app_instances.private_ips
}



output "rds_endpoint" {
  value = aws_db_instance.db.endpoint
}
