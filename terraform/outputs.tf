output "instance_acr_login_server" {
  value = azurerm_container_registry.instance_acr.login_server
}

output "reference_acr_login_server" {
  value = azurerm_container_registry.reference_acr.login_server
}