# ============================================
# Terraform Configuration for Azure Resources
# YouTube Clone DevOps Project
# ============================================

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.80"
    }
  }

  # Remote backend - Azure Storage
  backend "azurerm" {
    resource_group_name  = "rg-youtubeclone-tfstate"
    storage_account_name = "ytclonetfstate26538"
    container_name       = "tfstate"
    key                  = "youtube-clone.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}
