variable "location" {
  default = "eastus"
}

variable "resource_group_name" {
  default = "rg-containerapp"
}

variable "acr_name" {
  default = "acrtfexample"
}

variable "containerapp_name" {
  default = "my-containerapp"
}

variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}
variable "subscription_id" {}