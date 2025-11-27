
resource "azurerm_app_service_plan" "plan" {
  name                = var.plan_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku {
    tier = "Free"
    size = "F1"
  }
}

variable "plan_name" {}
variable "resource_group_name" {}
variable "location" {}

output "plan_id" {
  value = azurerm_app_service_plan.plan.id
}
