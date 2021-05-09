output "eks_node_group_status" {
  description = "Name of the worker nodes status"
  value       = aws_eks_node_group.workers[0].status
}