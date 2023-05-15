variable "datadog_key" {
}

variable "group_prefix" {
}

variable "storage_acct_name" {
}

variable "region" {
  default = "ukwest"
}

variable "os_publisher" {
  default = "Debian"
}

variable "os_offer" {
  default = "debian-10"
}

variable "os_sku" {
  default = "10"
}

variable "os_version" {
  default = "latest"
}

variable "machine_sku" {
  default = "Standard_B1s"
}
