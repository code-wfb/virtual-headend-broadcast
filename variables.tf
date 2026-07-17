variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "project_name" {
  type    = string
  default = "virtual-headend-broadcast"
}

variable "environment" {
  type    = string
  default = "prod"
}

variable "vpc_cidr" {
  type    = string
  default = "10.100.0.0/16"
}

variable "customer_gw_ip_isp_a" {
  type        = string
  description = "IP do Gateway Local da emissora - Provedor A"
}

variable "customer_gw_ip_isp_b" {
  type        = string
  description = "IP do Gateway Local da emissora - Provedor B"
}