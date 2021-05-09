
inputs = {
  
  region                           = "us-east-1"
  kubeconfig_path                  = "../kubeconfig"
  cluster_name                     = "terraform-eks-production"
  kubernetes_version               = "1.19"
  iam_master_name                  = "terraform-eks-production-master"
  iam_worker_name                  = "terraform-eks-production-worker"
  iam_worker_instance_profile_name = "terraform-eks-production-worker"
  node_groups = [
    {
      name          = "terraform-eks-production-nodegroup",
      desired_size  = 3,
      max_size      = 3,
      min_size      = 3,
      instance_type = "t2.large",
      disk_size     = 50
    },
  ]

}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    bucket         = "dirceu-test-terraform"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "my-lock-table"
  }
}

