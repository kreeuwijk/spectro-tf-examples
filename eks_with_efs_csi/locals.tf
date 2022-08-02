locals {
  eks_profile_map = {
    "Dev-EKS" = {
      id = data.spectrocloud_cluster_profile.dev-eks.id
      minimum_state = 0
      packs = []
    }
    "Dev-EKS-EFS" = {
      id = data.spectrocloud_cluster_profile.dev-eks-efs.id
      minimum_state = 1
      packs = [
        {
          name = "aws-efs"
          tag  = "1.3.6"
          values = templatefile("./config/efs.yaml", {
            fs_id : length(aws_efs_file_system.efs) > 0 ? aws_efs_file_system.efs[0].id : "null"
          })
        }
      ]
    }
  }
}