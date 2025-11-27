
resource "azurerm_storage_account" "storage" {
  name                     = var.storage_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  public_network_access_enabled = false
 
  network_rules {
    default_action = "Deny"
    bypass         = ["AzureServices"]
    ip_rules       = []
  }
}

variable "storage_name" {}
variable "resource_group_name" {}
variable "location" {}

output "storage_id" {
  value = azurerm_storage_account.storage.id
}
public_network_access_enabled = false
 
  network_rules {
    default_action = "Deny"
    bypass         = ["AzureServices"]
    ip_rules       = []
  }
