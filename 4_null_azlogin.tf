#+=======================================================================================
# Login to Azure
resource "null_resource" "az_login" {
  triggers = {
    version = local.file_version_name
  }
  
  provisioner "local-exec" {
    command = <<EOT
      az login --service-principal -u ${var.deployment.client_id} -p ${var.deployment.client_secret} --tenant ${var.deployment.tenant_id} --output tsv
      az account set --subscription ${var.deployment.subscription_id} --output tsv
    EOT
  }

  depends_on = []
}
