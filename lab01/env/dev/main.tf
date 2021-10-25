# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
  backend "azurerm" {
    resource_group_name = "infra-control-rg"
    storage_account_name = "iacucreativa"
    container_name = "tfstate"
    key = "dev.tfstate"
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

module "linux-server" {
  source           = "../../modules/servers"
  linux-password   = var.linux_password
  linux-user       = "adminfrb03"
  environment      = "dev"
  cantidad-servers = 1
} 

module "aks" {
  source = "../../modules/aks"
  resource_group_name = module.linux-server.resource-group-name
  location = module.linux-server.location
  client_id = var.client_id
  client_secret = var.client_secret
}

# module "k8s" {
#   source = "../../modules/k8s-deploy"
# }