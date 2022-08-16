resource "spectrocloud_cluster_profile" "profile" {
  name        = "aws-efs-example"
  description = "Example profile for AWS cluster with EBS and EFS"
  tags        = ["iac:terraform"]
  cloud       = "aws"
  type        = "cluster"
  version     = "1.0.0"

  pack {
    name         = data.spectrocloud_pack.os.name
    tag          = data.spectrocloud_pack.os.version
    uid          = data.spectrocloud_pack.os.id
    registry_uid = data.spectrocloud_pack.os.registry_uid
    values       = data.spectrocloud_pack.os.values
  }

  pack {
    name         = data.spectrocloud_pack.k8s.name
    tag          = data.spectrocloud_pack.k8s.version
    uid          = data.spectrocloud_pack.k8s.id
    registry_uid = data.spectrocloud_pack.k8s.registry_uid
    values       = data.spectrocloud_pack.k8s.values
  }

  pack {
    name         = data.spectrocloud_pack.cni.name
    tag          = data.spectrocloud_pack.cni.version
    uid          = data.spectrocloud_pack.cni.id
    registry_uid = data.spectrocloud_pack.cni.registry_uid
    values       = data.spectrocloud_pack.cni.values
  }

  pack {
    name         = data.spectrocloud_pack.csi.name
    tag          = data.spectrocloud_pack.csi.version
    uid          = data.spectrocloud_pack.csi.id
    registry_uid = data.spectrocloud_pack.csi.registry_uid
    values       = data.spectrocloud_pack.csi.values
  }

  pack {
    name         = data.spectrocloud_pack.efs.name
    tag          = data.spectrocloud_pack.efs.version
    uid          = data.spectrocloud_pack.efs.id
    registry_uid = data.spectrocloud_pack.efs.registry_uid
    values       = templatefile("${path.module}/config/csi-aws-efs.yaml",
                    {
                      fs-id = aws_efs_file_system.efs.id
                    })
  }

}
