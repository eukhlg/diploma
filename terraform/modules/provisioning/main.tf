resource "null_resource" "provision" {
  count = var.instances_count
  connection {
    user        = var.ssh_credentials.user
    private_key = file(var.ssh_credentials.private_key)
    host        = var.target_host_ip[count.index]
  }

  provisioner "local-exec" {
    command = var.local_exec_command
  }

  provisioner "file" {
    source      = var.file_source
    destination = var.file_destination
  }

  provisioner "remote-exec" {
    inline = var.remote_exec_inline
  }
}