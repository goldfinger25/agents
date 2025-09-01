data "azurerm_subscriptions" "available" {
}

output "available_subscriptions" {
  value = data.azurerm_subscriptions.available.subscriptions
}

output "first_available_subscription_display_name" {
  value = data.azurerm_subscriptions.available.subscriptions[0].display_name
}