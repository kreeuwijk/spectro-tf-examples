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

data "spectrocloud_pack" "efs" {
  name = "csi-aws-efs-add-on"
  registry_uid = data.spectrocloud_registry.registry.id
  version  = "1.4.0"
}

data "aws_caller_identity" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
  filter {
    name   = "region-name"
    values = [var.region]
  }
}

data "aws_vpc" "this" {
  tags  = {
    Name = "${spectrocloud_cluster_eks.cluster.name}-vpc"
  }
}

data "aws_eks_cluster" "this" {
  name = spectrocloud_cluster_eks.cluster.name
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_eks_cluster.this.vpc_config[0].vpc_id]
  }
  tags = {
    "sigs.k8s.io/cluster-api-provider-aws/role" = "private"
  }
}

data "aws_security_group" "eks" {
  vpc_id = data.aws_eks_cluster.this.vpc_config[0].vpc_id
  tags = {
    "aws:eks:cluster-name" = spectrocloud_cluster_eks.cluster.name
  }
}
