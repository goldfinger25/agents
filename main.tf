resource "azurerm_resource_group" "rg-agents" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_resource_group" "rg-network" {
  name     = var.resource_group_name
  location = var.location
}

# VNet and Subnet for ACI
resource "azurerm_virtual_network" "vnet" {
  name                = "devops-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-network.name
}

resource "azurerm_subnet" "aci-subnet" {
  name                 = "aci-subnet"
  resource_group_name  = azurerm_resource_group.rg-network.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
  # Required for VNet integration
  delegation {
    name = "aci-delegation"
    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
    }
  }
}

# Public IP for NAT Gateway
resource "azurerm_public_ip" "nat_gateway_ip" {
  name                = "devops-nat-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-network.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# NAT Gateway
resource "azurerm_nat_gateway" "nat_gateway" {
  name                    = "devops-nat-gateway"
  location                = var.location
  resource_group_name     = azurerm_resource_group.rg-network.name
  sku_name                 =  "Standard"
  idle_timeout_in_minutes = 4

}

  resource "azurerm_nat_gateway_public_ip_association" "example" {
  nat_gateway_id       = nat_gateway.nat_gateway_id
  public_ip_address_id = nat_gateway_ip.public_ip_address_id
}


# Associate NAT Gateway with the subnet
resource "azurerm_subnet_nat_gateway_association" "nat_gateway_association" {
  subnet_id       = azurerm_subnet.aci-subnet.id
  nat_gateway_id  = azurerm_nat_gateway.nat_gateway.id
}

resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg-agents.name
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = true
}

resource "azurerm_container_group" "devops_agent" {
  count               = var.agent_count
  name                = "devops-agent-${count.index}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-agents
  os_type             = "Linux"

  # VNet integration configuration
  subnet_ids = [azurerm_subnet.subnet.id]
  ip_address_type = "Private"
  
  container {
    name   = "devops-agent"
    image  = "${azurerm_container_registry.acr.login_server}/${var.acr_image_name}:${var.acr_image_tag}"
    cpu    = var.cpu_cores
    memory = var.memory_gb

    environment_variables = {
      AZP_URL   = var.devops_org_url
      AZP_TOKEN = var.devops_pat
      AZP_POOL  = var.devops_agent_pool
    }
  }
  
  # ACI VNet integration requires a SystemAssigned identity
  identity {
    type = "SystemAssigned"
  }

  restart_policy = "OnFailure"
}