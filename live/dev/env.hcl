# Configuration for the second, independently managed lab environment.
locals {
  resource_group_name = "rg-iaac-dev"
  location            = "centralindia"
  vnet_name           = "vnet-iaac-dev"
  vnet_cidr           = "10.43.0.0/16"
  subnet_name         = "snet-iaac-dev"
  subnet_cidr         = "10.43.1.0/24"
}
