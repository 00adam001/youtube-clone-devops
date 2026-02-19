# ============================================
# Azure Resources
# ============================================

# Resource Group (already exists - created manually)
data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

# ============================================
# Azure Container Registry (already exists - created manually)
# ============================================
data "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = data.azurerm_resource_group.main.name
}

# ============================================
# Log Analytics Workspace (for monitoring)
# ============================================
resource "azurerm_log_analytics_workspace" "main" {
  name                = "law-youtube-clone"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = var.tags
}

# ============================================
# Application Insights
# ============================================
resource "azurerm_application_insights" "main" {
  name                = "ai-youtube-clone"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  workspace_id        = azurerm_log_analytics_workspace.main.id
  application_type    = "web"
  tags                = var.tags
}

# ============================================
# Production Container Instance
# ============================================
resource "azurerm_container_group" "prod" {
  name                = var.webapp_name_prod
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  os_type             = "Linux"
  ip_address_type     = "Public"
  dns_name_label      = var.webapp_name_prod
  restart_policy      = "Always"
  tags                = merge(var.tags, { environment = "production" })

  container {
    name   = "youtube-clone"
    image  = "${data.azurerm_container_registry.acr.login_server}/youtube-clone:latest"
    cpu    = "0.5"
    memory = "0.5"

    ports {
      port     = 80
      protocol = "TCP"
    }
  }

  image_registry_credential {
    server   = data.azurerm_container_registry.acr.login_server
    username = data.azurerm_container_registry.acr.admin_username
    password = data.azurerm_container_registry.acr.admin_password
  }

  lifecycle {
    ignore_changes = [container]
  }
}

# ============================================
# Staging Container Instance
# ============================================
resource "azurerm_container_group" "staging" {
  name                = var.webapp_name_staging
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  os_type             = "Linux"
  ip_address_type     = "Public"
  dns_name_label      = var.webapp_name_staging
  restart_policy      = "Always"
  tags                = merge(var.tags, { environment = "staging" })

  container {
    name   = "youtube-clone"
    image  = "${data.azurerm_container_registry.acr.login_server}/youtube-clone:develop-latest"
    cpu    = "0.5"
    memory = "0.5"

    ports {
      port     = 80
      protocol = "TCP"
    }
  }

  image_registry_credential {
    server   = data.azurerm_container_registry.acr.login_server
    username = data.azurerm_container_registry.acr.admin_username
    password = data.azurerm_container_registry.acr.admin_password
  }

  lifecycle {
    ignore_changes = [container]
  }
}
