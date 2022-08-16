data "spectrocloud_cloudaccount_aws" "account" {
  name = var.cloudaccount
}

data "spectrocloud_registry" "registry" {
  name = "Public Repo"
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
  registry_uid = data.spectrocloud_registry.registry.id
  version  = "1.8.0"
}
