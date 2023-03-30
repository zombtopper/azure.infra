# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.49.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "terraform"
    storage_account_name = "terraformcore"
    container_name       = "core"
    key                  = "core.tfstate"
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}


#---- Core Resources ----#

# Create a resource group
resource "azurerm_resource_group" "core" {
  name     = "kubernetes"
  location = "centralus"
}


#---- AKS ----#

resource "azurerm_kubernetes_cluster" "example" {
  name                = "evergreen"
  location            = "centralus"
  resource_group_name = azurerm_resource_group.core.name
  dns_prefix          = "nile"
  sku_tier            = "Free"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

}