variable proxmox_api_url {
    type = string
    sensitive = true
}
variable proxmox_api_token_id {
    type = string
    sensitive = true
}
variable proxmox_api_token_secret {
    type = string
    sensitive = true
}
variable "ssh_public_key" {
  type = string
}

variable "gitlab_token" {
  type = string
  sensitive = true
}