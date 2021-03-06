variable "aws_vpc_name" {
  type        = string
  default = "OWASPJuiceShop-VPC"
  description = "Name of the VPC"
}

variable "eks_cluster_name" {
  type        = string
  default = "OWASPJuiceShop-EKS"
  description = "Name of the EKS Cluster"
}

variable "region" {
  default     = "eu-west-2"
  description = "AWS region"
}