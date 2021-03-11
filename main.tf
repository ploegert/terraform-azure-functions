
terraform {
  required_version = ">= 0.13"
  
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
