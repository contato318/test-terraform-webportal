# save the 'terraform output eks_kubeconfig > config', run 'mv config ~/.kube/config' to use it for kubectl
locals {
  kubeconfig = <<KUBECONFIG
apiVersion: v1
clusters:
- cluster:
    server: ${aws_eks_cluster.tf_eks.endpoint}
    certificate-authority-data: ${aws_eks_cluster.tf_eks.certificate_authority.0.data}
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: aws
  name: aws
current-context: aws
kind: Config
preferences: {}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws
      args:
        - --region
        - "${var.region}"
        - eks
        - get-token
        - --cluster-name
        - "${var.cluster_name}"
KUBECONFIG
}

resource "local_file" "kube-config" {
  content  = local.kubeconfig
  filename = var.kubeconfig_path
  depends_on = [ 
    aws_eks_cluster.tf_eks,
    aws_eks_node_group.workers
  ]  
}


resource "null_resource" "wait_for_kubernetes" {

  provisioner "local-exec" {
    command = <<EOF
while [ "$${RET}" -gt 0 ]; do
    kubectl get namespaces --kubeconfig=${var.kubeconfig_path}
    RET=$?
    if [ "$${RET}" -gt 0 ]; then
        sleep 10
    fi
done
EOF


    environment = {
      RET  = "1"
    }
  }
  depends_on = [ local_file.kube-config ]
}