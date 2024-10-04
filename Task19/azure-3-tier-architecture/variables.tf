variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "admin_password" {
  description = "Admin password for the virtual machines"
  type        = string
  default     = "P@ssw0rd123"  # Example that meets the requirements
}


