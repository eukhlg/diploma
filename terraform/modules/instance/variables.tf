variable "master_nodes" {
  description = "Count of manager nodes"
  type        = number
  default     = 1
}

variable "app_nodes" {
  description = "Count of worker nodes"
  type        = number
  default     = 1
}

variable "instance_family_image" {
  description = "Instance image"
  type        = string
  default     = "ubuntu-2204-lts"
}

variable "instance_platform_id" {
  description = "Instance Platform"
  type        = string
  default     = "standard-v3"
}

variable "vpc_subnet_id" {
  description = "VPC subnet network id"
  type        = string
}

variable "ssh_credentials" {
  description = "Credentials for connect to instances"
  type = object({
    user        = string
    private_key = string
    pub_key     = string
  })
  default = {
    user        = "evgeny"
    private_key = "~/.ssh/id_rsa"
    pub_key     = "~/.ssh/id_rsa.pub"
  }
}