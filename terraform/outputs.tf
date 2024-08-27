output "external_ip_address_manager" {
  value = module.k8s_cluster[*].external_ip_address_master
}

output "external_ip_address_worker" {
  value = module.k8s_cluster[*].external_ip_address_app
}