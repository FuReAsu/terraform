variable "do_token" {
  type = string
  sensitive = true
  description = "digital ocean api key"
}

variable "ssh_key" {
  type = string
}

variable "domain_name" {
  type = string
  description = "domain name to add the record to"
  default = "example.com"
}

variable "record_name" {
  type = string
  description = "A record name to add to domain"
  default = "@"
}

variable "region" {
  type = string
  description = "digital ocean region to deploy"
  default = "sgp1"
}

variable "droplet_name" {
  type = string
  description = "digital ocean droplet name"
  default = "example-droplet"
}

variable "env" {
  type = string
  description = "environment [ prod or dev ]"
}
