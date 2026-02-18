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
# App Service Plan (Linux)
# ============================================
resource "azurerm_service_plan" "main" {
  name                = var.app_service_plan_name
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  os_type             = "Linux"
  sku_name            = var.app_service_sku
  tags                = var.tags
}

# ============================================
# Log Analytics Workspace (for App Insights)
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
# Production Web App
# ============================================
resource "azurerm_linux_web_app" "prod" {
  name                = var.webapp_name_prod
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  service_plan_id     = azurerm_service_plan.main.id
  tags                = merge(var.tags, { environment = "production" })

  site_config {
    always_on = true

    application_stack {
      docker_registry_url      = "https://${data.azurerm_container_registry.acr.login_server}"
      docker_image_name        = "youtube-clone:latest"
      docker_registry_username = data.azurerm_container_registry.acr.admin_username
      docker_registry_password = data.azurerm_container_registry.acr.admin_password
    }

    health_check_path = "/health"
  }

  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
    "DOCKER_ENABLE_CI"                    = "true"
    "APPINSIGHTS_INSTRUMENTATIONKEY"      = azurerm_application_insights.main.instrumentation_key
  }
}

# ============================================
# Staging Web App
# ============================================
resource "azurerm_linux_web_app" "staging" {
  name                = var.webapp_name_staging
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  service_plan_id     = azurerm_service_plan.main.id
  tags                = merge(var.tags, { environment = "staging" })

  site_config {
    always_on = true

    application_stack {
      docker_registry_url      = "https://${data.azurerm_container_registry.acr.login_server}"
      docker_image_name        = "youtube-clone:develop-latest"
      docker_registry_username = data.azurerm_container_registry.acr.admin_username
      docker_registry_password = data.azurerm_container_registry.acr.admin_password
    }

    health_check_path = "/health"
  }

  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
    "DOCKER_ENABLE_CI"                    = "true"
    "APPINSIGHTS_INSTRUMENTATIONKEY"      = azurerm_application_insights.main.instrumentation_key
  }
}
