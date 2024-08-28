resource "null_resource" "ansible" {
  count      = var.installations_count
  connection {
    user        = var.ssh_credentials.user
    private_key = file(var.ssh_credentials.private_key)
    host        = var.target_host_ip[count.index]
  }
  
  provisioner "file" {
    source      = "../ansible/install_ansible.sh"
    destination = "/tmp/install_ansible.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install_ansible.sh",
      "/tmp/install_ansible.sh",
    ]
  }
}