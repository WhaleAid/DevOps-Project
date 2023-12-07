output "resource_group_name" {
  value = azurerm_resource_group.rg_main.name
}

output "resource_group_location" {
  value = azurerm_resource_group.rg_main.location
}

output "public_ip" {
  value = azurerm_public_ip.aks_public_ip.ip_address
}