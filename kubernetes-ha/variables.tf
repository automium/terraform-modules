variable "region" {
  default = "it-mil1"
}

variable "worker_count" { 
   default = "2"
}

variable "master_flavor" {
   default = "e3standard.x2"
}

variable "worker_flavor" {
   default = "e3standard.x3"
}

variable "floating_ip_pool" {
   default = "PublicNetwork"
}

variable "access-cidr" {
   default = "0.0.0.0/0"
}

variable "api-access-cidr" {
   default = "127.0.0.1/32"
}

variable "keyname" {}

variable "network_name" {}

variable "image" {}

variable "cloud_os_api_url" {}

variable "cloud_os_tenant_name" {}

variable "cloud_os_username" {}

variable "cloud_os_password" {}

variable "cloud_os_region" {}