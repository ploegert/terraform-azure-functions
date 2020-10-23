#+=======================================================================================
# Wait x after deploy
resource "time_sleep" "wait_x_seconds_after_deploy" {
  create_duration = local.time_delay_in_secs

  depends_on = [
    null_resource.deploy,
  ]
}

#+=======================================================================================
# Register vnet with function
resource "null_resource" "vnet_config" {
  provisioner "local-exec" {
    command = "az functionapp vnet-integration add -g ${var.common_vars.resource_group_name} -n  ${var.functionapp.fn_name} --vnet ${var.function_vnet.vnet_id} --subnet ${var.function_vnet.subnet_name}"
  }
 
  depends_on = [
    time_sleep.wait_x_seconds_after_deploy,
    null_resource.az_login,
    null_resource.az_subscription_set
  ]
}