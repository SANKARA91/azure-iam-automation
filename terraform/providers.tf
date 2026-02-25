terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.47"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.90"
    }
  }
}

provider "azuread" {
  tenant_id     = "9dc19d85-8c86-4774-8cb0-9e5375a00308"
  client_id     = "b6c375aa-4468-4621-9eee-d8ee90123a7c"
  client_secret = var.client_secret
}

provider "azurerm" {
  features {}
  tenant_id     = "9dc19d85-8c86-4774-8cb0-9e5375a00308"
  client_id     = "b6c375aa-4468-4621-9eee-d8ee90123a7c"
  client_secret = var.client_secret
  subscription_id = var.subscription_id
}