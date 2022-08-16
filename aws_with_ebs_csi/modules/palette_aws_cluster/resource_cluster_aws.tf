resource "spectrocloud_cluster_aws" "cluster" {
  name             = var.name
  tags             = ["managed:true", "owner:your_name"]
  cloud_account_id = data.spectrocloud_cloudaccount_aws.account.id

  cluster_profile {
    id = spectrocloud_cluster_profile.profile.id
  }

  cloud_config {
    region       = var.region
    ssh_key_name = var.sshkey
  }

  machine_pool {
    name                    = "master-pool"
    control_plane           = true
    control_plane_as_worker = false
    count                   = var.master_count
    instance_type           = var.master_instance_type
    disk_size_gb            = var.master_disk_size_gb
    azs                     = ["${var.region}a","${var.region}b","${var.region}c"]
  }

  machine_pool {
    name          = "worker-pool"
    count         = var.worker_count
    instance_type = var.worker_instance_type
    disk_size_gb  = var.worker_disk_size_gb
    azs           = ["${var.region}a","${var.region}b","${var.region}c"]
  }

}
