# ============================================
# Outputs
# ============================================

output "resource_group_name" {
  description = "Name of the resource group"
  value       = data.azurerm_resource_group.main.name
}

output "acr_login_server" {
  description = "ACR login server URL"
  value       = data.azurerm_container_registry.acr.login_server
}

output "acr_admin_username" {
  description = "ACR admin username"
  value       = data.azurerm_container_registry.acr.admin_username
  sensitive   = true
}

output "acr_admin_password" {
  description = "ACR admin password"
  value       = data.azurerm_container_registry.acr.admin_password
  sensitive   = true
}

output "webapp_prod_url" {
  description = "Production Web App URL"
  value       = "https://${azurerm_linux_web_app.prod.default_hostname}"
}

output "webapp_staging_url" {
  description = "Staging Web App URL"
  value       = "https://${azurerm_linux_web_app.staging.default_hostname}"
}

output "app_insights_instrumentation_key" {
  description = "Application Insights instrumentation key"
  value       = azurerm_application_insights.main.instrumentation_key
  sensitive   = true
}

output "app_insights_connection_string" {
  description = "Application Insights connection string"
  value       = azurerm_application_insights.main.connection_string
  sensitive   = true
}
