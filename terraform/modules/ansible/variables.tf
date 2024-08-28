variable "installations_count" {
  description = "Count of installations"
  type        = number
}

variable "ssh_credentials" {
  description = "Instance SSH Credentials"
  type = object({
    user        = string
    private_key = string
    pub_key     = string
  })
}

variable "target_host_ip" {
  description = "Installation target host IP"
  type = any
}
