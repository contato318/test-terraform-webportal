resource "aws_cloudwatch_log_group" "tf_eks" {
  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = 7
}

resource "aws_kms_key" "eks" {
  description = "EKS Secret Encryption Key"
  enable_key_rotation = true
}

resource "aws_eks_cluster" "tf_eks" {
  name     = var.cluster_name
  role_arn = aws_iam_role.master.arn
  version  = var.kubernetes_version
  enabled_cluster_log_types = ["api","audit","authenticator","controllerManager","scheduler",]
  encryption_config {
      provider {
        key_arn = aws_kms_key.eks.arn
      } 

      resources        = ["secrets"]
    }
  
  


  vpc_config {
    security_group_ids = [aws_security_group.master.id]
    subnet_ids         = aws_subnet.eks[*].id
    endpoint_private_access=true
    #checkov:skip=CKV_AWS_39:In production, this would be disabled, as we would use a host bastion
    #checkov:skip=CKV_AWS_38:In production, this would be disabled, as we would use a host bastion
    endpoint_public_access=true
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSServicePolicy,
    aws_cloudwatch_log_group.tf_eks,
    aws_kms_key.eks,
  ]
}

resource "aws_eks_node_group" "workers" {
  for_each        = local.node_groups_expanded

  cluster_name    = var.cluster_name
  node_group_name = each.value["name"]
  node_role_arn   = aws_iam_role.worker.arn
  subnet_ids      = aws_subnet.eks[*].id
  instance_types  = [each.value["instance_type"]]
  ami_type        = each.value["ami_type"]
  disk_size       = each.value["disk_size"]

  scaling_config {
    desired_size = each.value["desired_size"]
    max_size     = each.value["max_size"]
    min_size     = each.value["min_size"]
  }

  labels = {
    node_group = each.value["name"]
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
    aws_eks_cluster.tf_eks
  ]
}

