variable "resource_group_name" {
  description = "Name of the resource group created by the existing lab unit."
  type        = string
}

variable "location" {
  description = "Azure region of the virtual network."
  type        = string
}

variable "vnet_name" {
  type = string
}

variable "vnet_cidr" {
  type = string
}

variable "subnet_name" {
  type = string
}

variable "subnet_cidr" {
  type = string
}
