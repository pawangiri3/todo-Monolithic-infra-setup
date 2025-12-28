terraform {
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
  subscription_id = "2fe6adb6-b639-4804-8d25-87b437c9cbe6"
  # Configuration options
}