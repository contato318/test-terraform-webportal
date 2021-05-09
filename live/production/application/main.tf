module "kubernetes-ingress" {
  source              = "../../../modules/kubernetes-ingress"
  kubeconfig_path     = var.kubeconfig_path
  
}


module "web-portal" {
  source              = "../../../modules/web-portal"
  aws_dns_zone_id     = var.aws_dns_zone_id 
  fqdn                = var.fqdn
  wildcard            = var.wildcard
  lb                  = module.kubernetes-ingress.lb_address
  app_passwd          = var.app_passwd
  mariadb_root_passwd = var.mariadb_root_passwd
  mariadb_passwd      = var.mariadb_passwd 
  region              = var.region
  access_key          = var.access_key
  secret_key          = var.secret_key
  kubeconfig_path     = var.kubeconfig_path

  
}

variable "aws_dns_zone_id" {}
variable "fqdn" {}
variable "wildcard" {} 

variable "kubeconfig_path" {
  type      = string
  default   = "../kubeconfig"
  sensitive = true
}

variable "app_passwd" {
  type      = string
  sensitive = true
}

variable "mariadb_root_passwd" {
  type      = string
  sensitive = true
}

variable "mariadb_passwd" {
  type      = string
  sensitive = true
}

variable "access_key" {
  type      = string
  sensitive = true
}
variable "secret_key" {
  type      = string
  sensitive = true
}

variable "region" {
  type    = string
  default = "us-east-1"
}