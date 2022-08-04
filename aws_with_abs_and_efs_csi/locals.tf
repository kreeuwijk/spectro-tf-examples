data "spectrocloud_cluster_profile" "dev-aws" {
  # This profile needs to contain the "csi-aws-ebs" v1.8.0 and "csi-aws-efs-add-on" v1.4.0 packs
  name    = "Dev-AWS"
  version = "1.0.0"
}

locals {
  aws_profiles = [
    {
      id            = data.spectrocloud_cluster_profile.dev-aws.id
      packs         = [
        {
          name = "csi-aws-ebs"
          tag  = "1.8.0"
          values = file("./config/csi-aws-efs.yaml")
        },
        {
          name = "csi-aws-efs-add-on"
          tag  = "1.4.0"
          values = templatefile("./config/csi-aws-efs.yaml", {
            fs-id        : aws_efs_file_system.efs.id
          })
        }
      ]
    }
  ]
}