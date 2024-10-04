variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "app_subnet_id" {
  description = "ID of the application subnet"
  type        = string
}

variable "app_vm_size" {
  description = "Size of the application-tier VMs"
  default     = "Standard_DS1_v2"
}

variable "app_vm_count" {
  description = "Number of application-tier VMs"
  default     = 2
}

variable "admin_username" {
  description = "Admin username for the VMs"
  type        = string
}

variable "admin_password" {
  description = "Admin password for the VMs"
  default     = "P@ssw0rd123" 
  type        = string
}
variable "web_subnet_address_prefix" {
  description = "The CIDR block for the web subnet"
  type        = string
}
