variable "instances_count" {
  description = "Count of Instances"
  type        = number
  default     = 1
}

variable "ssh_credentials" {
  description = "Instance SSH Credentials"
  type = object({
    user        = string
    private_key = string
    pub_key     = string
  })
    default = {
    user        = "admin"
    private_key = "~/.ssh/id_rsa"
    pub_key     = "~/.ssh/id_rsa.pub"
  }
}

variable "target_host_ip" {
  description = "Installation target host IP"
  type        = any
}

variable "file_source" {
  description = "File Source"
  type        = string
  default     = "/dev/null"
}

variable "file_destination" {
  description = "File Destination"
  type        = string
  default     = "/tmp/null"
}

variable "remote_exec_inline" {
  description = "Remote Shell Command"
  type        = list(any)
  default     = ["echo No remote exec command passed"]
}

variable "local_exec_command" {
  description = "Local Shell Command"
  type        = string
  default     = "echo No local exec command passed"
}

