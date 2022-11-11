terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.30.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "terraform-stetes"
    storage_account_name = "terraformssctatesstorage"
    container_name       = "devtfstate"
    key                  = "dev.terraform.tfstate"
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "tf_rg_app2" {
  name     = "app2_rg"
  location = "Brazil South"
}

resource "azurerm_service_plan" "tf_service_plan" {
  name                = "app2-service-plan"
  resource_group_name = azurerm_resource_group.tf_rg_app2.name
  location            = azurerm_resource_group.tf_rg_app2.location
  os_type             = "Linux"
  sku_name            = "F1"
}

resource "azurerm_linux_web_app" "tf_web_app" {
  name                = "app2-web-app"
  resource_group_name = azurerm_resource_group.tf_rg_app2.name
  location            = azurerm_resource_group.tf_rg_app2.location
  service_plan_id     = azurerm_service_plan.tf_service_plan.id

  site_config {
    always_on = false
    application_stack {
      docker_image     = ""
      docker_image_tag = ""
    }
  }
}
