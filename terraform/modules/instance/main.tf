data "yandex_compute_image" "my_image" {
  family = var.instance_family_image
}

resource "yandex_compute_instance" "k8s-master" {
  count       = var.master_nodes
  platform_id = var.instance_platform_id
  hostname    = "k8s-mst-${count.index}"
  name        = yandex_compute_instance.k8s-master.hostname

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.my_image.id
      size     = 15
    }
  }

  network_interface {
    subnet_id = var.vpc_subnet_id
    nat       = true
  }

  metadata = {
    user-data = "#cloud-config\nusers:\n  - name: ${var.ssh_credentials.user}\n    groups: sudo\n    shell: /bin/bash\n    sudo: ['ALL=(ALL) NOPASSWD:ALL']\n    ssh-authorized-keys:\n      - ${file("${var.ssh_credentials.pub_key}")}"
  }
}


resource "yandex_compute_instance" "k8s-app" {
  count       = var.app_nodes
  platform_id = var.instance_platform_id
  hostname    = "k8s-app-${count.index}"
  name        = yandex_compute_instance.k8s-app.hostname

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.my_image.id
      size     = 15
    }
  }

  network_interface {
    subnet_id = var.vpc_subnet_id
    nat       = true
  }

  metadata = {
    user-data = "#cloud-config\nusers:\n  - name: ${var.ssh_credentials.user}\n    groups: sudo\n    shell: /bin/bash\n    sudo: ['ALL=(ALL) NOPASSWD:ALL']\n    ssh-authorized-keys:\n      - ${file("${var.ssh_credentials.pub_key}")}"
  }

}