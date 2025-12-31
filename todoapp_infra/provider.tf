terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.57.0"
    }
  }
  # backend "azurerm" {
  #   resource_group_name = "value"
  #   storage_account_name = "value"
  #   container_name = "value"
  #   key = "value" 
  # }
}

provider "azurerm" {
  features {

  }
  subscription_id = "af6aa2e9-539c-4948-b07c-d9aef5cc7c92"
  # Configuration options
}