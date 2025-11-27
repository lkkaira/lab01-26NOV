
resource "azurerm_app_service" "webapp" {
  name                = var.webapp_name
  resource_group_name = var.resource_group_name
  location            = var.location
  app_service_plan_id = var.plan_id
}

variable "webapp_name" {}
variable "resource_group_name" {}
variable "location" {}
variable "plan_id" {}

output "webapp_url" {
  value = azurerm_app_service.webapp.default_site_hostname
}
