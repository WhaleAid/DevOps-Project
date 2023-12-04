terraform {
  required_providers {
    azurerm = {
        source  = "hashicorp/azurerm"
        version = "=3.0.0"
    }
  }
}

provider azurerm {
  features {}
}

resource "azurerm_resource_group" "rg_main" {
    name = var.resource_group
    location = var.location
    tags = {
        environment = "Terraform Lab"
    }
}

module "redis" {
    source = "./modules/redis"
    account_name= var.redis_account_name
    resource_group_name = azurerm_resource_group.rg_main.name
}