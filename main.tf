
terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.45.1"
    }
    vault = {
      source = "hashicorp/vault"
      version = ">= 2.15.0"
    }
    consul = {
      source = "hashicorp/consul"
      version = ">= 2.10.0"
    }
    http = {
      source = "hashicorp/http"
      version = ">= 2.0.0"
    }
    time = {
      source = "hashicorp/time"
      version = ">= 0.6.0"
    }
    null = {
      source = "hashicorp/null"
      version = ">= 3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# ==================================================
# Locals
# ==================================================
locals{
  time_delay_in_secs        = "60s"
  vault_path_infra          = "${var.hashicorp.key_path.base}/${var.env_name}/infra/${var.hashicorp.key_path.version}"
  file_version_name         = format("%s-%s.zip", var.functionapp.full_name, var.function_version) 

  default_site_config = {
    # "always_on"                 = var.service_plan_sku["tier"] == "Free" ? false : true
    # "use_32_bit_worker_process" = var.service_plan_sku["tier"] == "Free" ? true : false
    ftps_state  = "Disabled"
    always_on = true
  }

}
