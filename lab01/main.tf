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

# Configure the Microsoft Azure Provider.
provider "azurerm" {
  features {}
}


# Create a resource group.
resource "azurerm_resource_group" "terraformLab" {
  name     = "iacPrueba"
  location = "centralus"
  tags = {
    "env" = "dev"
  }
} 

# Create a virtual network.
resource "azurerm_virtual_network" "vnet" {
  name                = "iacvnet"
  location            = azurerm_resource_group.terraformLab.location
  resource_group_name = azurerm_resource_group.terraformLab.name
  address_space       = ["10.0.0.0/16"]
  tags = {
    "env" = "dev"
  }
}

# Create a subnet.
resource "azurerm_subnet" "subnet1" {
  name                 = "iacsubnet1"
  resource_group_name  = azurerm_resource_group.terraformLab.name
  address_prefixes     = ["10.0.0.0/24"]
  virtual_network_name = azurerm_virtual_network.vnet.name
}

# Create a network interface.
resource "azurerm_network_interface" "nic" {
  name                = "iacnic"
  location            = azurerm_resource_group.terraformLab.location
  resource_group_name = azurerm_resource_group.terraformLab.name
  ip_configuration {
    name                          = "iacipconfig"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip.id
  }
  tags = {
    "env" = "dev"
  }
}

# Create a virtual machine.
resource "azurerm_virtual_machine" "vm" {
  name                  = "iacvm1"
  location              = azurerm_resource_group.terraformLab.location
  resource_group_name   = azurerm_resource_group.terraformLab.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  vm_size               = "Standard_D1_v2"

  delete_data_disks_on_termination = "true"
  delete_os_disk_on_termination    = "true"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "iacos"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "iacuacreativa01"
    admin_username = "iacadmin"
    admin_password = "Iacreativa01"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    "env" = "dev"
  }
}

# Create a public ip.
resource "azurerm_public_ip" "publicip" {
  name                = "iacpublicip"
  location            = azurerm_resource_group.terraformLab.location
  resource_group_name = azurerm_resource_group.terraformLab.name
  allocation_method   = "Static"
  tags = {
    "env" = "dev"
  }
}

# Create a network security group.
resource "azurerm_network_security_group" "iacsecgroup" {
  name                = "iacSecGroup"
  location            = azurerm_resource_group.terraformLab.location
  resource_group_name = azurerm_resource_group.terraformLab.name
  tags = {
    "env" = "dev"
  }
}

# Create a network security rule (Deny all).
resource "azurerm_network_security_rule" "rule01" {
  name                        = "DenegarTodo"
  network_security_group_name = azurerm_network_security_group.iacsecgroup.name
  resource_group_name         = azurerm_resource_group.terraformLab.name
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

# Create a network security rule (Allow port 80).
resource "azurerm_network_security_rule" "rule02" {
  name                        = "permitael80"
  network_security_group_name = azurerm_network_security_group.iacsecgroup.name
  resource_group_name         = azurerm_resource_group.terraformLab.name
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

# Create a network interface security group association.
resource "azurerm_network_interface_security_group_association" "sgassociation" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.iacsecgroup.id
} 