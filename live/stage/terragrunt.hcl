
inputs = {
  
  region                           = "us-east-1"
  kubeconfig_path                  = "../kubeconfig"
  cluster_name                     = "terraform-eks-stage"
  kubernetes_version               = "1.19"
  iam_master_name                  = "terraform-eks-stage-master"
  iam_worker_name                  = "terraform-eks-stage-worker"
  iam_worker_instance_profile_name = "terraform-eks-stage-worker"
  node_groups = [
    {
      name          = "terraform-eks-stage-nodegroup",
      desired_size  = 1,
      max_size      = 1,
      min_size      = 1,
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

