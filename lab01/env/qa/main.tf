# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

variable "linux-password" {}

module "linux-server" {
  source           = "../../modules/servers"
  linux-password   = "${var.linux-password}"
  linux-user       = "adminqa"
  environment      = "qa"
  cantidad-servers = 2
}

module "acr" {
  source         = "../../modules/container-registry"
  resource-group = module.linux-server.resource-group-name
  location       = module.linux-server.location
} 