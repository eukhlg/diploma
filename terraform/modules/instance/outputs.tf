output "instance_external_ip_address" {
  value = yandex_compute_instance.node[*].network_interface.0.nat_ip_address
}

output "instance_internal_ip_address" {
  value = yandex_compute_instance.node[*].network_interface.0.ip_address
}

output "instance_count" {
  value = var.instance_count
}

output "instance_name" {
  value = var.instance_name
}

output "instance_ssh_credentials" {
  value = var.ssh_credentials
}