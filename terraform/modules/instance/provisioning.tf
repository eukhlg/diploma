resource "null_resource" "k8s-master" {
  count      = var.master_nodes
  depends_on = [yandex_compute_instance.k8s-master]
  connection {
    user        = var.ssh_credentials.user
    private_key = file(var.ssh_credentials.private_key)
    host        = yandex_compute_instance.k8s-master[count.index].network_interface.0.nat_ip_address
  }
  
/*
  provisioner "file" {
    source      = "../docker-compose.yml"
    destination = "docker-compose.yml"
  }

  provisioner "remote-exec" {
    inline = [
      "curl -fsSL https://get.docker.com | sh",
      "sudo usermod -aG docker $USER",
      "sudo docker swarm init",
      "sleep 10",
      "echo COMPLETED"
    ]
  }
*/
}

resource "null_resource" "k8s-join" {
  count      = var.master_nodes
  depends_on = [yandex_compute_instance.k8s-master, null_resource.k8s-master]
  connection {
    user        = var.ssh_credentials.user
    private_key = file(var.ssh_credentials.private_key)
    host        = yandex_compute_instance.k8s-master[count.index].network_interface.0.nat_ip_address
  }
/*
  provisioner "local-exec" {
    command = "TOKEN=$(ssh -i ${var.ssh_credentials.private_key} -o StrictHostKeyChecking=no ${var.ssh_credentials.user}@${yandex_compute_instance.k8s-master[count.index].network_interface.0.nat_ip_address} docker swarm join-token -q worker); echo \"#!/usr/bin/env bash\nsudo docker swarm join --token $TOKEN ${yandex_compute_instance.k8s-master[count.index].network_interface.0.nat_ip_address}:2377\nexit 0\" >| join.sh"
  }
*/
}

resource "null_resource" "k8s-app" {
  count      = var.app_nodes
  depends_on = [yandex_compute_instance.k8s-app, null_resource.k8s-join]
  connection {
    user        = var.ssh_credentials.user
    private_key = file(var.ssh_credentials.private_key)
    host        = yandex_compute_instance.k8s-app[count.index].network_interface.0.nat_ip_address
  }

/*
  provisioner "file" {
    source      = "join.sh"
    destination = "join.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "curl -fsSL https://get.docker.com | sh",
      "sudo usermod -aG docker $USER",
      "chmod +x ~/join.sh",
      "~/join.sh"
    ]
  }
*/
}

resource "null_resource" "docker-swarm-manager-start" {
  depends_on = [yandex_compute_instance.k8s-master, null_resource.k8s-join]
  connection {
    user        = var.ssh_credentials.user
    private_key = file(var.ssh_credentials.private_key)
    host        = yandex_compute_instance.k8s-master[0].network_interface.0.nat_ip_address
  }
/*
  provisioner "remote-exec" {
    inline = [
      "docker stack deploy --compose-file ~/docker-compose.yml sockshop-swarm"
    ]
  }

  provisioner "local-exec" {
    command = "rm join.sh"
  }
*/
}
