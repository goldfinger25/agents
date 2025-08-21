terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.40.0"
    }
  }
}


resource "azurerm_subscription" "sub" {
  alias             = "Baseline Sub"
  subscription_name = "Baseline Sub"
  subscription_id   = "e83a6760-22e0-44ea-a806-d6475fd8ee45"
}
resource "azurerm_resource_group" "rg" {
  name = var.resource_group_name
  location = var.location
}

resource "azurerm_container_registry" "acr" {
  name = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  sku = "Basic"
  admin_enabled = true
}

resource "azurerm_container_group" "devops_agent" {
  count = var.agent_count
  name = "devops-agent-${count.index}"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_address_type = "Private"
  os_type = "Linux"

  container {
    name = "devops-agent"
    image = "${azurerm_container_registry.acr.login_server}/${var.acr_image_name}:${var.acr_image_tag}"
    cpu = var.cpu_cores
    memory = var.memory_gb

    environment_variables = {
      AZP_URL = var.devops_org_url
      AZP_TOKEN = var.devops_pat
      AZP_POOL = var.devops_agent_pool
    }

    ports {
      port = 80
      protocol = "TCP"
    }
  }

  identity {
    type = "SystemAssigned"
  }

  restart_policy = "OnFailure"
}