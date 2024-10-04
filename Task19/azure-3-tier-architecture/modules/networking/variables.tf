variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure location"
  default     = "West Europe"
  type        = string
}

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "vnet_cidr" {
  description = "CIDR block for the VNet"
  default     = "10.0.0.0/16"
  type        = string
}

variable "subnet_web_name" {
  description = "Name of the web subnet"
  type        = string
}

variable "subnet_web_cidr" {
  description = "CIDR block for the web subnet"
  default     = "10.0.1.0/24"
  type        = string
}

variable "subnet_app_name" {
  description = "Name of the app subnet"
  type        = string
}

variable "subnet_app_cidr" {
  description = "CIDR block for the app subnet"
  default     = "10.0.2.0/24"
  type        = string
}

variable "subnet_db_name" {
  description = "Name of the database subnet"
  type        = string
}

variable "subnet_db_cidr" {
  description = "CIDR block for the database subnet"
  default     = "10.0.3.0/24"
  type        = string
}

variable "nat_gateway_name" {
  description = "Name of the NAT Gateway"
  type        = string
}

variable "web_subnet_address_prefix" {
  type = string
}

variable "app_subnet_address_prefix" {
  type = string
}