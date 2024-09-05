variable "token" {
  description = "YC OAuth token"
  type        = string
  default     = "token"
}

# export TF_VAR_token=
# https://yandex.cloud/ru/docs/iam/concepts/authorization/oauth-token

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

