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
  default     = [" "]
}

variable "local_exec_command" {
  description = "Local Shell Command"
  type        = string
  default     = " "
}

