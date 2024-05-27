terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.42.0"
    }
  }
  #Minimum version required
  required_version = ">= 1.3.8"
  backend "azurerm" {
    resource_group_name = var.backed_resource_group_name
    storage_account_name = var.backend_storage_account_name
    container_name = var.backend_container_name
    key = var.backend_key
  }
}
