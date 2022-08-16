data "spectrocloud_cloudaccount_aws" "account" {
  name = var.cloudaccount
}

data "spectrocloud_registry" "registry" {
  name = "Public Repo"
}

data "spectrocloud_pack" "os" {
  name           = "amazon-linux-eks"
  registry_uid   = data.spectrocloud_registry.registry.id
  version        = "1.0.0"
}

data "spectrocloud_pack" "k8s" {
  name    = "kubernetes-eks"
  registry_uid = data.spectrocloud_registry.registry.id
  version = "1.22"
}

data "spectrocloud_pack" "cni" {
  name    = "cni-aws-vpc-eks"
  registry_uid = data.spectrocloud_registry.registry.id
  version = "1.0"
}

data "spectrocloud_pack" "csi" {
  name = "csi-aws-ebs"
  registry_uid = data.spectrocloud_registry.registry.id
  version  = "1.8.0"
}

data "aws_caller_identity" "current" {}

data "aws_eks_cluster" "this" {
  name = spectrocloud_cluster_eks.cluster.name
}