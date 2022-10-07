resource "spectrocloud_cluster_eks" "cluster" {
  name             = var.name
  tags             = ["managed:true", "owner:your_name"]
  cloud_account_id = data.spectrocloud_cloudaccount_aws.account.id

  cluster_profile {
    id    = spectrocloud_cluster_profile.profile.id
    pack {
      name   = data.spectrocloud_pack.k8s.name
      tag    = data.spectrocloud_pack.k8s.version
      values = replace(data.spectrocloud_pack.k8s.values, "#managedMachinePool:", yamlencode(
        {"managedMachinePool": {"roleAdditionalPolicies": [
          "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
        ]}}))
    }

    pack {
      name   = data.spectrocloud_pack.csi.name
      tag    = data.spectrocloud_pack.csi.version
      values = templatefile("${path.module}/config/csi-aws-ebs.yaml", {
        ebs-role-arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/iam-irsa-role-${var.name}"
      })
    }
  }

  cloud_config {
    region          = var.region
    ssh_key_name    = var.sshkey
    endpoint_access = "public"
  }

  machine_pool {
    name          = "worker-pool"
    min           = var.worker_min
    count         = var.worker_count
    max           = var.worker_max
    instance_type = var.worker_instance_type
    disk_size_gb  = var.worker_disk_size_gb
    azs           = var.azs
  }

}
