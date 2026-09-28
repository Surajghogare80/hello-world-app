output "resource_group_name" {
  value = data.azurerm_resource_group.main.name
}

output "resource_group_location" {
  value = data.azurerm_resource_group.main.location
}

output "virtual_network_name" {
  value = azurerm_virtual_network.main.name
}

output "subnet_name" {
  value = azurerm_subnet.main.name
}

output "public_ip_address" {
  value = azurerm_public_ip.main.ip_address
}

output "network_security_group_name" {
  value = azurerm_network_security_group.main.name
}

output "network_interface_name" {
  value = azurerm_network_interface.main.name
}

output "virtual_machine_name" {
  value = azurerm_linux_virtual_machine.main.name
}