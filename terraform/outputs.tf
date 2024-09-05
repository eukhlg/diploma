output "k8s_master_internal_ip_address" {
  value = module.k8s_master.instance_internal_ip_address
}

output "k8s_master_external_ip_address" {
  value = module.k8s_master.instance_external_ip_address
}

output "k8s_app_internal_ip_address" {
  value = module.k8s_app.instance_internal_ip_address
}

output "k8s_app_external_ip_address" {
  value = module.k8s_app.instance_external_ip_address
}

output "srv_management_internal_ip_address" {
  value = module.srv_management.instance_internal_ip_address
}

output "srv_management_external_ip_address" {
  value = module.srv_management.instance_external_ip_address
}