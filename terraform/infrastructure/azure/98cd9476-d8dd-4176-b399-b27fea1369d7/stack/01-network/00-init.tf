terraform {
  required_version = ">= 0.14.4"

  backend "azurerm" {}
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.45.1"
    }
  }
}

provider "azurerm" {
  features {}
}
