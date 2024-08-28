data "yandex_compute_image" "my_image" {
  family = var.instance_family_image
}

resource "yandex_compute_instance" "node" {
  count       = var.instance_count
  platform_id = var.instance_platform_id
  hostname    = "${var.instance_name}-${count.index + 1}"
  name        = "${var.instance_name}-${count.index + 1}"

  resources {
    cores  = var.instance_cores
    memory = var.instance_memory
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.my_image.id
      size     = var.instance_disk
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

resource "yandex_dns_recordset" "host" {
  count   = var.instance_count
  zone_id = var.dns_zone_id
  name    = "${var.instance_name}-${count.index + 1}.app.local."
  type    = "A"
  ttl     = 200
  data    = [yandex_compute_instance.node[count.index].network_interface.0.ip_address]
}