output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

output "devops_agent_names" {
  value = azurerm_container_group.devops_agent[*].name
}
