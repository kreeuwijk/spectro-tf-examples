data "spectrocloud_cluster_profile" "dev-eks" {
  # This profile needs to contain the "csi-aws-ebs" and "csi-aws-efs-add-on" packs
  name    = "Dev-EKS"
  version = "1.0.0"
}

locals {
  eks_profiles = [
    {
      id            = data.spectrocloud_cluster_profile.dev-eks.id
      packs         = [
        {
          name = "csi-aws-efs-add-on"
          tag  = "1.4.0"
          values = templatefile("./config/efs.yaml", {
            fs-id        : aws_efs_file_system.efs.id,
            efs-role-arn : "arn:aws:iam::${var.aws_account_number}:role/EFS-CSI-Driver-Role-${var.sc_eks_cluster_name}"
          })
        }
      ]
    }
  ]
}