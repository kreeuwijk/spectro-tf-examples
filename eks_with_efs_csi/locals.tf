data "spectrocloud_cluster_profile" "dev-eks" {
  # This profile needs to contain the "csi-aws-ebs" v1.8.0 and "csi-aws-efs-add-on" v1.4.0 packs
  name    = "Dev-EKS"
  version = "1.0.0"
}

locals {
  eks_profiles = [
    {
      id            = data.spectrocloud_cluster_profile.dev-eks.id
      packs         = [
        {
          name = "csi-aws-ebs"
          tag  = "1.8.0"
          values = templatefile("./config/csi-aws-ebs.yaml", {
            ebs-role-arn : "arn:aws:iam::${var.aws_account_number}:role/EBS-CSI-Driver-Role-${var.sc_eks_cluster_name}"
          })
        },
        {
          name = "csi-aws-efs-add-on"
          tag  = "1.4.0"
          values = templatefile("./config/csi-aws-efs.yaml", {
            fs-id        : aws_efs_file_system.efs.id,
            efs-role-arn : "arn:aws:iam::${var.aws_account_number}:role/EFS-CSI-Driver-Role-${var.sc_eks_cluster_name}"
          })
        }
      ]
    }
  ]
}