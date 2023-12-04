resource "azurerm_resource_group" "rg_main" {
    name = "rs-ESGI-${var.student_name}"
    location = var.resource_location
    tags = {
        environment = "Terraform Lab"
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
        vm_size    = "standard_a2m_v2"
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