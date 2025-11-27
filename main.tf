
module "storage" {
  source              = "./modules/storage"
  storage_name        = var.storage_name
  resource_group_name = var.resource_group_name
  location            = var.location
}

module "appserviceplan" {
  source              = "./modules/appserviceplan"
  plan_name           = var.plan_name
  resource_group_name = var.resource_group_name
  location            = var.location
}

module "webapp" {
  source              = "./modules/webapp"
  webapp_name         = var.webapp_name
  resource_group_name = var.resource_group_name
  location            = var.location
  plan_id             = module.appserviceplan.plan_id
}

module "loganalytics" {
  source              = "./modules/loganalytics"
  workspace_name      = var.workspace_name
  resource_group_name = var.resource_group_name
  location            = var.location
}
