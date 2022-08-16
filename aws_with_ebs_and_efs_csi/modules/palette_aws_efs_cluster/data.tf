data "spectrocloud_cloudaccount_aws" "account" {
  name = var.cloudaccount
}

data "spectrocloud_registry" "registry" {
  name = "Public Repo"
}

data "spectrocloud_registry" "registry2" {
  name = "Dreamworx Packs"
}

data "spectrocloud_pack" "os" {
  name           = "ubuntu-aws"
  registry_uid   = data.spectrocloud_registry.registry.id
  version        = "20.04"
}

data "spectrocloud_pack" "k8s" {
  name    = "kubernetes"
  registry_uid = data.spectrocloud_registry.registry.id
  version = "1.23.4"
}

data "spectrocloud_pack" "cni" {
  name    = "cni-calico"
  registry_uid = data.spectrocloud_registry.registry.id
  version = "3.22.0"
}

data "spectrocloud_pack" "csi" {
  name = "csi-aws-ebs"
  registry_uid = data.spectrocloud_registry.registry2.id
  version  = "1.8.0"
}

data "spectrocloud_pack" "efs" {
  name = "csi-aws-efs-add-on"
  registry_uid = data.spectrocloud_registry.registry2.id
  version  = "1.4.0"
}

data "aws_availability_zones" "available" {
  state = "available"
  filter {
    name   = "region-name"
    values = [var.region]
  }
}

data "aws_vpc" "this" {
  tags  = {
    Name = "${spectrocloud_cluster_aws.cluster.name}-vpc"
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.this.id]
  }
  tags = {
    "sigs.k8s.io/cluster-api-provider-aws/role" = "private"
  }
}

data "aws_security_group" "aws" {
  vpc_id = data.aws_vpc.this.id
  name = "default"
}