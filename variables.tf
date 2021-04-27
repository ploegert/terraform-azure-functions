# ==================================================
# Provider info:
# ==================================================
variable "deployment" {
  type = object({
    client_id           = string
    client_secret       = string
    client_obj_id       = string
    subscription_id     = string
    tenant_id           = string
  })
}

variable "artifacts" {
  type = object({
    subscription    = string
    resource_group  = string
    storage_account = string
    container_name  = string
    account_key     = string
    artusername     = string
    artpassword     = string
    arturl          = string
    artfunctionrepo = string
  })
}

variable "function_version" { }
variable "env_name" { }


variable "common_vars" {
  type = object({
    location = string
    resource_group_name = string
    app_service_plan_id = string
    appinsights_id = string
    keyvault_id = string
  }) # endof type
} # endof functions

variable "function_vnet" {
  type = object({
    vnet_id = string
    subnet_name = string
    default_action = string
    ip_rules = list(string)
    virtual_network_subnet_ids = list(string)
  })
}

variable "functionapp" {
  type = object({
    fn_name = string
    full_name = string
    functions = list(string)

    storage_account = object({
      name = string
      tier = string
      replication_type = string
    })

    keyvault = object({
      cert_permissions = list(string)
      key_permissions = list(string)
      secret_permissions = list(string)
    }) # endof keyvault

    eventgrid_topics = list(string)

  }) # endof type
} # endof functions

# ==================================================
# hashicorp Variables:
# ==================================================
variable "hashicorp" {
  type = object({
    vault            = object({
      address = string
      token = string
    })
    consul            = object({
      address = string
      token = string
      datacenter = string
    })
    key_path           = object({
      base = string
      version = string
    })
  })
}


# ==================================================
# Other Variables - Tags:
# ==================================================
variable "tags" {
  type        = map
  description = "Collection of the tags referenced by the Azure deployment"
  default = {
    source      = "terraform"
    environment = "dev"
    costCenter  = "OpenBlue Twin"
  }
}


variable app_settings {
  type        = map
}



variable "toggle_configure_dynatrace" { default="true" }
variable "toggle_configure_kv_access_policy" { default="true" }
variable "toggle_configure_vnet_connection" { default="true" }
variable "toggle_configure_consul_node" { default="true" }
variable "toggle_configure_consul_service" { default="true" }
variable "toggle_configure_infra_to_vault" { default="true" }
variable "toggle_download_from_sa" { default="false" }
variable "toggle_download_from_artifactory" { default="true" }


variable "logs" {
  description = "(Optional) A logs block as defined below."
  type        = list
  default     = []
  /*
  application_logs - (Optional) An application_logs block as defined below.
    azure_blob_storage - (Optional) An azure_blob_storage block as defined below.
      level - (Required) The level at which to log. Possible values include Error, Warning, Information, Verbose and Off. NOTE: this field is not available for http_logs
      sas_url - (Required) The URL to the storage container, with a Service SAS token appended. NOTE: there is currently no means of generating Service SAS tokens with the azurerm provider.
      retention_in_days - (Required) The number of days to retain logs for.
  http_logs - (Optional) An http_logs block as defined below.
    file_system - (Optional) A file_system block as defined below.
      retention_in_days - (Required) The number of days to retain logs for.
      retention_in_mb - (Required) The maximum size in megabytes that http log files can use before being removed.
    azure_blob_storage - (Optional) An azure_blob_storage block as defined below.
      level - (Required) The level at which to log. Possible values include Error, Warning, Information, Verbose and Off. NOTE: this field is not available for http_logs
      sas_url - (Required) The URL to the storage container, with a Service SAS token appended. NOTE: there is currently no means of generating Service SAS tokens with the azurerm provider.
      retention_in_days - (Required) The number of days to retain logs for.
  */
}


variable "site_config" {
  description = "(Optional) A site_config block as defined below."
  type        = any
  default     = {}
  /*
  always_on - (Optional) Should the Function App be loaded at all times? Defaults to false.
  cors - (Optional) A cors block as defined below.
  ftps_state - (Optional) State of FTP / FTPS service for this function app. Possible values include: AllAllowed, FtpsOnly and Disabled. Defaults to AllAllowed.
  health_check_path - (Optional) Path which will be checked for this function app health.
  http2_enabled - (Optional) Specifies whether or not the http2 protocol should be enabled. Defaults to false.
  ip_restriction - (Optional) A List of objects representing ip restrictions as defined below.
    NOTE: User has to explicitly set ip_restriction to empty slice ([]) to remove it.
  linux_fx_version - (Optional) Linux App Framework and version for the AppService, e.g. DOCKER|(golang:latest).
  min_tls_version - (Optional) The minimum supported TLS version for the function app. Possible values are 1.0, 1.1, and 1.2. Defaults to 1.2 for new function apps.
  pre_warmed_instance_count - (Optional) The number of pre-warmed instances for this function app. Only affects apps on the Premium plan.
  scm_ip_restriction - (Optional) A List of objects representing ip restrictions as defined below.
    NOTE User has to explicitly set scm_ip_restriction to empty slice ([]) to remove it.
  scm_type - (Optional) The type of Source Control used by the Function App. Valid values include: BitBucketGit, BitBucketHg, CodePlexGit, CodePlexHg, Dropbox, ExternalGit, ExternalHg, GitHub, LocalGit, None (default), OneDrive, Tfs, VSO, and VSTSRM
    NOTE: This setting is incompatible with the source_control block which updates this value based on the setting provided.
  scm_use_main_ip_restriction - (Optional) IP security restrictions for scm to use main. Defaults to false.
    NOTE Any scm_ip_restriction blocks configured are ignored by the service when scm_use_main_ip_restriction is set to true. Any scm restrictions will become active if this is subsequently set to false or removed.
  use_32_bit_worker_process - (Optional) Should the Function App run in 32 bit mode, rather than 64 bit mode? Defaults to true.
    Note: when using an App Service Plan in the Free or Shared Tiers use_32_bit_worker_process must be set to true.
  websockets_enabled - (Optional) Should WebSockets be enabled?
  */
}
