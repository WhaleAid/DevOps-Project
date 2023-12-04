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
    name = "rg-ESGI-${var.student_name}"
    location = var.location
    tags = {
        environment = "Terraform project"
    }
}

resource "azurerm_container_registry" "acr_main" {
    name = "acrESGI${var.student_name}"
    resource_group_name = azurerm_resource_group.rg_main.name
    location = azurerm_resource_group.rg_main.location
    sku = "Standard"
    admin_enabled = true
    tags = {
        environment = "Terraform Lab"
    }
}

resource "azurerm_kubernetes_cluster" "aks_esgi" {
    name                = "aksESGI${var.student_name}"
    location            = azurerm_resource_group.rg_main.location
    resource_group_name = azurerm_resource_group.rg_main.name
    dns_prefix          = "aksESGI-${var.student_name}"

    default_node_pool {
        name       = "default"
        node_count = 1
        vm_size    = "Standard_B2s"
    }

    identity {
        type = "SystemAssigned"
    }
}

resource "azurerm_role_assignment" "acr_pull_role" {
    scope                = azurerm_container_registry.acr_main.id
    role_definition_name = "AcrPull"
    principal_id         = azurerm_kubernetes_cluster.aks_esgi.kubelet_identity.0.object_id
}