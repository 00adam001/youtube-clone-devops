# ============================================
# Variables
# ============================================

variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
  default     = "rg-youtubeclone"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "East US"
}

variable "acr_name" {
  description = "Name of the Azure Container Registry"
  type        = string
  default     = "ytcloneacr8568"
}

variable "webapp_name_prod" {
  description = "Name of the production Web App"
  type        = string
  default     = "youtube-clone-prod"
}

variable "webapp_name_staging" {
  description = "Name of the staging Web App"
  type        = string
  default     = "youtube-clone-staging"
}

variable "acr_sku" {
  description = "SKU for Azure Container Registry"
  type        = string
  default     = "Basic"
}

variable "tags" {
  description = "Tags for all resources"
  type        = map(string)
  default = {
    project     = "youtube-clone"
    environment = "devops"
    managed_by  = "terraform"
  }
}
