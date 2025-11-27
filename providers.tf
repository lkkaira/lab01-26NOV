
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0" # or the version you need
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "679f3d56-bed2-429f-9e31-4d7bf67e14c7"
}
