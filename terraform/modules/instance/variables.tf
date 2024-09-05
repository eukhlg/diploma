variable "instance_name" {
  description = "Instance Name"
  type        = string
  default     = "node"
}

variable "instance_cores" {
  description = "Instance CPU Cores"
  type        = number
  default     = 2
}

variable "instance_memory" {
  description = "Instance RAM"
  type        = number
  default     = 4
}

variable "instance_disk" {
  description = "Instance Disk Size"
  type        = number
  default     = 15
}

variable "instance_count" {
  description = "Instances Count"
  type        = number
  default     = 1
}

variable "instance_family_image" {
  description = "Instance Image"
  type        = string
  default     = "debian-12"
}

variable "instance_platform_id" {
  description = "Instance Platform"
  type        = string
  default     = "standard-v3"
}

variable "vpc_subnet_id" {
  description = "VPC Subnet Network Id"
  type        = string
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

variable "dns_zone_id" {
  description = "Instance DNS zone"
  type        = string
}