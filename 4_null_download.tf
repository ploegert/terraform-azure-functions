#+=======================================================================================
# Download dataflowapi function
azure_command = "az storage blob download --file ./${local.file_version_name} --name ${local.file_version_name} --subscription ${var.artifacts.subscription} --container-name ${var.artifacts.container_name} --account-name ${var.artifacts.storage_account}  --account-key ${var.artifacts.account_key}"
jfrog_command = "jfrog rt download  --flat=true"
download_command = var.is_azure_artifact ? azure_command : jfrog_command 
resource "null_resource" "download" {
  triggers = {
    version = local.file_version_name
  }
  provisioner "local-exec" {
    
	command = local.download_command
	}
 
  depends_on = [
    azurerm_function_app.fnapp,
    null_resource.az_login,
    null_resource.az_subscription_set
  ]
}
