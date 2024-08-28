terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  token     = var.token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
}

resource "yandex_vpc_network" "network" {
  name = "app-network"
}

resource "yandex_vpc_subnet" "subnet" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["172.20.1.0/24"]
}

resource "yandex_dns_zone" "local" {
  name        = "app-private-zone"
  description = "DNS zone for internal network"

  #labels = {
  #  label1 = "label-1-value"
  #}

  zone                = "app.local."
  public              = false
  private_networks    = [yandex_vpc_network.network.id]
  deletion_protection = false
}

module "k8s_master" {
  source          = "./modules/instance"
  vpc_subnet_id   = yandex_vpc_subnet.subnet.id
  instance_name   = "k8s-master"
  dns_zone_id     = yandex_dns_zone.local.id
  ssh_credentials = var.ssh_credentials
  instance_count  = 2
}

module "k8s_app" {
  source          = "./modules/instance"
  vpc_subnet_id   = yandex_vpc_subnet.subnet.id
  instance_name   = "k8s-app"
  dns_zone_id     = yandex_dns_zone.local.id
  ssh_credentials = var.ssh_credentials
  instance_count  = 2
}

module "srv_management" {
  source          = "./modules/instance"
  depends_on      = [module.k8s_master, module.k8s_app]
  vpc_subnet_id   = yandex_vpc_subnet.subnet.id
  instance_name   = "srv-mgmt"
  dns_zone_id     = yandex_dns_zone.local.id
  ssh_credentials = var.ssh_credentials
}

module "srv_management_config" {
  source           = "./modules/provisioning"
  depends_on       = [module.srv_management]
  ssh_credentials  = module.srv_management.instance_ssh_credentials
  target_host_ip   = module.srv_management.instance_external_ip_address
  file_source      = "../management/management_config.sh"
  file_destination = "/tmp/management_config.sh"
  remote_exec_inline = [
    "chmod +x /tmp/management_config.sh",
    "/tmp/management_config.sh"
  ]

}

module "inventory" {
  source             = "./modules/provisioning"
  depends_on         = [module.srv_management]
  ssh_credentials    = module.srv_management.instance_ssh_credentials
  target_host_ip     = module.srv_management.instance_external_ip_address
  local_exec_command = "chmod +x ../management/build_inventory.sh && ../management/build_inventory.sh > ../management/ansible/inventory/inventory.ini"
}

module "ssh-copy" {
  source           = "./modules/provisioning"
  depends_on       = [module.srv_management]
  ssh_credentials  = module.srv_management.instance_ssh_credentials
  target_host_ip   = module.srv_management.instance_external_ip_address
  file_source      = var.ssh_credentials.private_key
  file_destination = ".ssh/id_rsa"
}

module "kubespray" {
  source           = "./modules/provisioning"
  depends_on       = [module.srv_management_config]
  ssh_credentials  = module.srv_management.instance_ssh_credentials
  target_host_ip   = module.srv_management.instance_external_ip_address
  file_source      = "../management/ansible/inventory"
  file_destination = "./inventory"
  remote_exec_inline = [
    "docker run -it --rm --mount type=bind,source=./inventory,dst=/inventory --mount type=bind,source=./.ssh/id_rsa,dst=/root/.ssh/id_rsa quay.io/kubespray/kubespray:v2.25.0 ansible-playbook -i /inventory/inventory.ini --private-key /root/.ssh/id_rsa cluster.yml --become"
  ]
}