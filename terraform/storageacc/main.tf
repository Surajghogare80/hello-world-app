terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  required_version = ">= 1.5.0"
}

provider "azurerm" {
  resource_provider_registrations = "none"

  features {}

  subscription_id = var.subscription_id
}

# Existing Azure Sandbox Resource Group
data "azurerm_resource_group" "sandbox" {
  name = var.resource_group_name
}

# Storage Account
resource "azurerm_storage_account" "storage" {
  name                     = "storage987654surajtest80"
  resource_group_name      = data.azurerm_resource_group.sandbox.name
  location                 = data.azurerm_resource_group.sandbox.location

  account_tier             = "Standard"
  account_replication_type = "LRS"

  min_tls_version = "TLS1_2"

  tags = {
    Environment = "Learning"
    ManagedBy   = "Terraform"
  }
}

# Outputs
output "storage_account_name" {
  value = azurerm_storage_account.storage.name
}

output "storage_account_id" {
  value = azurerm_storage_account.storage.id
}

output "resource_group_name" {
  value = data.azurerm_resource_group.sandbox.name
}

output "resource_group_location" {
  value = data.azurerm_resource_group.sandbox.location
}