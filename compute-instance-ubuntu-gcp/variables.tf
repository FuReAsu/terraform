variable "region" {
  default = "us-central1"
  description = "Region to deploy the compute instances in"
}

variable "zone" {
  default = "us-central1-a"
  description = "Which zone of the region to deploy the compute instances in"
}

variable "project" {
  description = "Google Cloud Project ID"
}

variable "instance_name" {
  default  = "compute-instance"
  description = "Name of the compute instance"
}
