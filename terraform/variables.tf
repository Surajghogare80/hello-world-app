variable "subscription_id" {
  description = "Azure Sandbox Subscription ID"
  type        = string
}

variable "resource_group_name" {
  description = "Existing Azure Sandbox Resource Group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastus"
}

variable "ssh_public_key_path" {
  description = "Path to SSH public key"
  type        = string
}