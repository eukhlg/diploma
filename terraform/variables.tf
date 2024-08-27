variable "token" {
  description = "YC OAuth token"
  type        = string
  default     = "token"
}

# export TF_VAR_token=

variable "cloud_id" {
  description = "YC Cloud ID"
  type        = string
  default     = "cloud_id"
}

# export TF_VAR_cloud_id=

variable "folder_id" {
  description = "YC Folder ID"
  type        = string
  default     = "folder_id"
}

# export TF_VAR_folder_id=

variable "zone" {
  description = "YC default zone"
  type        = string
  default     = "ru-central1-a"
}

locals {
  man_ip = ["95.140.147.80/32"]
}