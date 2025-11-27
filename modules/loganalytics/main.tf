
resource "azurerm_log_analytics_workspace" "workspace" {
  name                = var.workspace_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "PerGB2018"
}

variable "workspace_name" {}
variable "resource_group_name" {}
variable "location" {}

output "workspace_id" {
  value = azurerm_log_analytics_workspace.workspace.id
}
