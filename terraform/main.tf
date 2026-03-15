terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~>2.5"
    }
  }
}

provider "azurerm" {
  features {}
}