module "eks" {
  source                           = "../../../modules/eks"
  region                           = var.region
  access_key                       = var.access_key
  secret_key                       = var.secret_key
  cluster_name                     = var.cluster_name
  kubernetes_version               = var.kubernetes_version 
  accessing_computer_ips           = var.accessing_computer_ips 
  iam_master_name                  = var.iam_master_name
  iam_worker_name                  = var.iam_worker_name
  iam_worker_instance_profile_name = var.iam_worker_instance_profile_name
  kubeconfig_path                  = var.kubeconfig_path
  node_groups                      = var.node_groups 
}


variable "region" {
  type    = string
  default = "us-east-1"
}
variable "kubeconfig_path" {
  type      = string
  default   = "../kubeconfig"
  sensitive = true
}

variable "cluster_name" {}
variable "kubernetes_version" {}
variable "accessing_computer_ips" {
  type        = list(string)
}
variable "iam_master_name" {}
variable "iam_worker_name" {}
variable "iam_worker_instance_profile_name" {}
variable "node_groups" {
  type = list(object({
    name          = string
    desired_size  = number
    max_size      = number
    min_size      = number
    instance_type = string
  }))
} 

variable "access_key" {
  type      = string
  sensitive = true
}
variable "secret_key" {
  type      = string
  sensitive = true
}