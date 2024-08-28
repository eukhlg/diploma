terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
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

module "k8s_master" {
  source          = "./modules/instance"
  vpc_subnet_id   = yandex_vpc_subnet.subnet.id
  instance_name   = "k8s-master"
  instance_count  = 2
}

module "k8s_app" {
  source          = "./modules/instance"
  vpc_subnet_id   = yandex_vpc_subnet.subnet.id
  instance_name   = "k8s-app"
  instance_count  = 5
}

module "srv_management" {
  source          = "./modules/instance"
  vpc_subnet_id   = yandex_vpc_subnet.subnet.id
  instance_name   = "srv-mgmt"
  instance_count  = 2
}

module "ansible" {
  source          = "./modules/ansible"
  depends_on = [module.srv_management]
  installations_count = module.srv_management.instance_count
  ssh_credentials = module.srv_management.instance_ssh_credentials
  target_host_ip = module.srv_management.instance_external_ip_address
}