output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

output "devops_agent_names" {
  value = azurerm_container_group.devops_agent[*].name
}
output "available_subscriptions_id" {
  value = data.azurerm_subscriptions.available.id
}
#output "available_subscriptions_display_name" {
 # value = data.azurerm_subscriptions.available.display_name 
#}
