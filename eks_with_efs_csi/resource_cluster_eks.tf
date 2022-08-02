data "spectrocloud_cloudaccount_aws" "account" {
  name = "aws-spectro"
}

data "spectrocloud_cluster_profile" "dev-eks" {
  name = "Dev-EKS"
  version = "1.0.0"
}

data "spectrocloud_cluster_profile" "dev-eks-efs" {
  name = "Dev-EKS-EFS"
  version = "1.0.0"
}

data "external" "get_cluster_state" {
  program = ["bash", "get_cluster_state.sh"]
  query = {
    CLUSTER_NAME = var.sc_eks_cluster_name
    SC_HOST      = var.sc_host
    SC_API_KEY   = var.sc_api_key
    SC_PROJECT   = var.sc_project_name
  }
}

resource "spectrocloud_cluster_eks" "cluster" {
  name             = var.sc_eks_cluster_name
  tags             = ["managed:true", "owner:my_name"]
  cloud_account_id = data.spectrocloud_cloudaccount_aws.account.id

  dynamic "cluster_profile" {
    for_each = {for key, val in local.eks_profile_map : key => val if val.minimum_state <= tonumber(data.external.get_cluster_state.result.state)}
    content {
      id = cluster_profile.value.id
      dynamic "pack" {
        for_each = cluster_profile.value.packs
        content {
          name   = pack.value.name
          tag    = pack.value.tag
          values = pack.value.values
        }
      }
    }
  }

  cloud_config {
    region       = "eu-west-3"
  }

  machine_pool {
    name          = "worker-pool"
    count         = 3
    instance_type = "t3.large"
    disk_size_gb  = 60
  }

}
