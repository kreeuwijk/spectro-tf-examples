data "spectrocloud_cloudaccount_aws" "account" {
  name = "aws-spectro"
}

resource "spectrocloud_cluster_aws" "cluster" {
  name             = var.sc_aws_cluster_name
  tags             = ["managed:true", "owner:your_name"]
  cloud_account_id = data.spectrocloud_cloudaccount_aws.account.id

  dynamic "cluster_profile" {
    for_each = local.aws_profiles
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
    ssh_key_name = "kevinr-eu-west-3"
    region = "eu-west-3"
  }

  machine_pool {
    name                    = "master-pool"
    control_plane           = true
    control_plane_as_worker = false
    count                   = 1
    instance_type           = "t3.large"
    disk_size_gb            = 60
    azs                     = ["eu-west-3a","eu-west-3b","eu-west-3c"]
  }

  machine_pool {
    name          = "worker-pool"
    count         = 2
    instance_type = "t3.large"
    disk_size_gb  = 60
    azs           = ["eu-west-3a","eu-west-3b","eu-west-3c"]
  }

}
