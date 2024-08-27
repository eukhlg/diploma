output "external_ip_address_master" {
  value = yandex_compute_instance.k8s-master[*].network_interface.0.nat_ip_address
}

output "external_ip_address_app" {
  value = yandex_compute_instance.k8s-app[*].network_interface.0.nat_ip_address
}