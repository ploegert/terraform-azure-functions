#+=======================================================================================
# Wait x after function creation
resource "time_sleep" "wait_x_seconds_after_creation" {
  create_duration = local.time_delay_in_secs

  depends_on = [
    azurerm_function_app.fnapp,
    null_resource.download,
    null_resource.az_login,
    null_resource.az_subscription_set
  ]  
}

#+=======================================================================================
# Deploy function
resource "null_resource" "deploy" {
  triggers = {
    version = local.file_version_name
  }
  provisioner "local-exec" {
    command = <<EOT
      az login --service-principal -u ${var.deployment.client_id} -p ${var.deployment.client_secret} --tenant ${var.deployment.tenant_id}
      az account set --subscription ${var.deployment.subscription_id}
      az functionapp deployment source config-zip -g ${var.common_vars.resource_group_name} -n ${var.functionapp.fn_name} --src ./${local.file_version_name}
    EOT
  }
 
  depends_on = [
    azurerm_function_app.fnapp,
    time_sleep.wait_x_seconds_after_creation,
    null_resource.download,
    null_resource.az_login,
    null_resource.az_subscription_set
  ]
}
