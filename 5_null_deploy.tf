#+=======================================================================================
# Wait x after function creation
resource "time_sleep" "wait_x_seconds_after_creation" {
  create_duration = local.time_delay_in_secs

  depends_on = [
    azurerm_function_app.fnapp
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
      az login --service-principal -u ${var.deployment.client_id} -p ${var.deployment.client_secret} --tenant ${var.deployment.tenant_id} --output tsv
      az account set --subscription ${var.deployment.subscription_id} --output tsv
      az storage blob download --file ./${local.file_version_name} --name ${local.file_version_name} --subscription ${var.artifacts.subscription} --container-name ${var.artifacts.container_name} --account-name ${var.artifacts.storage_account}  --account-key ${var.artifacts.account_key}
      az functionapp deployment source config-zip -g ${var.common_vars.resource_group_name} -n ${var.functionapp.fn_name} --src ./${local.file_version_name}
      az functionapp config appsettings delete -g ${var.common_vars.resource_group_name} -n  ${var.functionapp.fn_name} --setting-names AzureWebJobsDashboard
    EOT
  }
 
  depends_on = [
    azurerm_function_app.fnapp,
    time_sleep.wait_x_seconds_after_creation
  ]
}
