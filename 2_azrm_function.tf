#+=======================================================================================
# azurerm_function_app.functionapp
resource "azurerm_function_app" "fnapp" {
  name                       = var.functionapp.fn_name
  location                   = var.common_vars.location
  resource_group_name        = var.common_vars.resource_group_name
  version                    = "3"
  app_service_plan_id        = var.common_vars.app_service_plan_id
  storage_account_name       = azurerm_storage_account.fn_sa.name
  storage_account_access_key = azurerm_storage_account.fn_sa.primary_access_key
  tags                       = var.tags

  identity {
    type = "SystemAssigned"
  }

  app_settings = var.app_settings

  dynamic "site_config" {
    for_each = [merge(local.default_site_config, var.site_config)]

    content {
      always_on                   = lookup(site_config.value, "always_on", null)
      ftps_state                  = lookup(site_config.value, "ftps_state", null)
      health_check_path           = lookup(site_config.value, "health_check_path", null)
      http2_enabled               = lookup(site_config.value, "http2_enabled", null)
      ip_restriction              = lookup(site_config.value, "ip_restriction", null)
      linux_fx_version            = lookup(site_config.value, "linux_fx_version", null)
      min_tls_version             = lookup(site_config.value, "min_tls_version", null)
      pre_warmed_instance_count   = lookup(site_config.value, "pre_warmed_instance_count", null)
      scm_use_main_ip_restriction = lookup(site_config.value, "scm_use_main_ip_restriction", null)
      scm_ip_restriction          = lookup(site_config.value, "scm_ip_restriction", null)
      scm_type                    = lookup(site_config.value, "scm_type", null)
      use_32_bit_worker_process   = lookup(site_config.value, "use_32_bit_worker_process", null)
      websockets_enabled          = lookup(site_config.value, "websockets_enabled", null)

      dynamic "cors" {
        for_each = lookup(site_config.value, "cors", [])
        content {
          allowed_origins     = cors.value.allowed_origins
          support_credentials = lookup(cors.value, "support_credentials", null)
        }
      }
    }
  }

  dynamic "auth_settings" {
    for_each = lookup(var.settings, "auth_settings", {}) != {} ? [1] : []

    content {
      enabled                        = lookup(var.settings.auth_settings, "enabled", false)
      additional_login_params        = lookup(var.settings.auth_settings, "additional_login_params", null)
      allowed_external_redirect_urls = lookup(var.settings.auth_settings, "allowed_external_redirect_urls", null)
      default_provider               = lookup(var.settings.auth_settings, "default_provider", null)
      issuer                         = lookup(var.settings.auth_settings, "issuer", null)
      runtime_version                = lookup(var.settings.auth_settings, "runtime_version", null)
      token_refresh_extension_hours  = lookup(var.settings.auth_settings, "token_refresh_extension_hours", null)
      token_store_enabled            = lookup(var.settings.auth_settings, "token_store_enabled", null)
      unauthenticated_client_action  = lookup(var.settings.auth_settings, "unauthenticated_client_action", null)

      dynamic "active_directory" {
        for_each = lookup(var.settings.auth_settings, "active_directory", {}) != {} ? [1] : []

        content {
          client_id         = var.settings.auth_settings.active_directory.client_id
          client_secret     = lookup(var.settings.auth_settings.active_directory, "client_secret", null)
          allowed_audiences = lookup(var.settings.auth_settings.active_directory, "allowed_audiences", null)
        }
      }

      dynamic "facebook" {
        for_each = lookup(var.settings.auth_settings, "facebook", {}) != {} ? [1] : []

        content {
          app_id       = var.settings.auth_settings.facebook.app_id
          app_secret   = var.settings.auth_settings.facebook.app_secret
          oauth_scopes = lookup(var.settings.auth_settings.facebook, "oauth_scopes", null)
        }
      }

      dynamic "google" {
        for_each = lookup(var.settings.auth_settings, "google", {}) != {} ? [1] : []

        content {
          client_id     = var.settings.auth_settings.google.client_id
          client_secret = var.settings.auth_settings.google.client_secret
          oauth_scopes  = lookup(var.settings.auth_settings.google, "oauth_scopes", null)
        }
      }

      dynamic "microsoft" {
        for_each = lookup(var.settings.auth_settings, "microsoft", {}) != {} ? [1] : []

        content {
          client_id     = var.settings.auth_settings.microsoft.client_id
          client_secret = var.settings.auth_settings.microsoft.client_secret
          oauth_scopes  = lookup(var.settings.auth_settings.microsoft, "oauth_scopes", null)
        }
      }

      dynamic "twitter" {
        for_each = lookup(var.settings.auth_settings, "twitter", {}) != {} ? [1] : []

        content {
          consumer_key    = var.settings.auth_settings.twitter.consumer_key
          consumer_secret = var.settings.auth_settings.twitter.consumer_secret
        }
      }
    }
  }

  
  depends_on          = [
      azurerm_storage_account.fn_sa
    ] 
}