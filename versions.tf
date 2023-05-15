terraform {
  required_version = ">= 1.1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.96.0"
    }

    template = {
      source  = "hashicorp/template"
      version = "~>2.1"
    }

    time = {
      source  = "hashicorp/time"
      version = "~>0.7"
    }

    local = {
      source  = "hashicorp/local"
      version = "2.1.0"
    }
  }
}
