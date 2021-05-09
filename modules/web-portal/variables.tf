
variable "region" {
  type        = string
  description = "AWS Region"
}

variable "access_key" {
  type      = string
  sensitive = true
}
variable "secret_key" {
  type      = string
  sensitive = true
}
variable "namespace" {
  type        = string
  default     = "web-portal"
}

variable "aws_dns_zone_id" {
  type        = string
  description = "aws_zone_id"
}

variable "kubeconfig_path" {
  type = string
  default = "./kubeconfig"
  description = "Kubeconfig path"
}

variable "lb" {
  type        = string
  description = "Address of ingress lb"
}

variable "wildcard" {
  type        = string
  description = "Wildcard domain"
}
variable "fqdn" {
  type        = string
  description = "Portal FQDN"
}

variable "app_passwd" {
  type        = string
  description = "App helm value wordpressPassword"
}

variable "mariadb_root_passwd" {
  type        = string
  description = "App helm value mariadb.auth.rootPassword"
}

variable "mariadb_passwd" {
  type        = string
  description = "App helm value mariadb.auth.password"
}