terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.40.0"
    }
  }
  backend "azurerm" {
      resource_group_name  = "rg_tfstate_01"
      storage_account_name = "atbuildtfstate01"
      container_name       = "tfstate"
      key                  = "VZTPuiSZv/6dO5iyiVOAn896EQU5rXJdb5Rk3KRmD1G4KLENj9MYF5uo2aK+QOTJgHR7IG00ExAp+AStHUcUEw=="
  }
}

provider "azurerm" {
  features {}
}