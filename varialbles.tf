variable "resource_group_name" {
  description = "The name of the resource group."
  type = string
  default = "aci-devops-agents-rg"
}

variable "location" {
  description = "The Azure region to deploy the resources."
  type = string
  default = "East US"
}

variable "acr_name" {
  description = "The name of the Azure Container Registry."
  type = string
  default = "mydevopsagentsacr"
}

variable "acr_image_name" {
  description = "The name of the Docker image."
  type = string
  default = "devops-agent"
}

variable "acr_image_tag" {
  description = "The tag for the Docker image."
  type = string
  default = "latest"
}

variable "devops_org_url" {
  description = "The URL for your Azure DevOps organization (e.g., https://dev.azure.com/myorg)."
  type = string
}

variable "devops_pat" {
  description = "The Personal Access Token for Azure DevOps."
  type = string
  sensitive = true
}

variable "devops_agent_pool" {
  description = "The name of the agent pool in Azure DevOps."
  type = string
  default = "ACIAgents"
}

variable "agent_count" {
  description = "The number of DevOps agents to create."
  type = number
  default = 5
}

variable "cpu_cores" {
  description = "The number of CPU cores for each container."
  type = number
  default = 1
}

variable "memory_gb" {
  description = "The amount of memory in GB for each container."
  type = number
  default = 1.5
}