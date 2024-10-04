variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "db_subnet_id" {
  description = "ID of the database subnet"
  type        = string
}

variable "db_vm_size" {
  description = "Size of the database-tier VMs"
  default     = "Standard_DS1_v2"
}

variable "db_vm_count" {
  description = "Number of database-tier VMs"
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
variable "app_subnet_address_prefix" {
  description = "The CIDR block for the application subnet"
  type        = string
}
