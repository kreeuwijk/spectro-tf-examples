resource "aws_iam_policy" "eks-efs-csi-policy" {
  name        = "EFS-CSI-Driver-${var.sc_eks_cluster_name}"
  description = "Policy to enable AWS EFS CSI on EKS cluster."
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "elasticfilesystem:DescribeAccessPoints",
                "elasticfilesystem:DescribeFileSystems",
                "elasticfilesystem:DescribeMountTargets",
                "ec2:DescribeAvailabilityZones"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "elasticfilesystem:CreateAccessPoint"
            ],
            "Resource": "*",
            "Condition": {
                "StringLike": {
                    "aws:RequestTag/efs.csi.aws.com/cluster": "true"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": "elasticfilesystem:DeleteAccessPoint",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "aws:ResourceTag/efs.csi.aws.com/cluster": "true"
                }
            }
        }
    ]
}
EOF
}

resource "aws_iam_role" "eks-efs-csi-role" {
  name  = "EFS-CSI-Driver-Role-${var.sc_eks_cluster_name}"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRoleWithWebIdentity"
        Effect    = "Allow"
        Sid       = ""
        Principal = {
          "Federated": "arn:aws:iam::${var.aws_account_number}:oidc-provider/${substr(data.aws_eks_cluster.this.identity[0].oidc[0].issuer, 8, -1)}"
        }
        Condition = {
          StringEquals = {
            "${substr(data.aws_eks_cluster.this.identity[0].oidc[0].issuer, 8, -1)}:aud" = "sts.amazonaws.com"
          }
        }
      },
    ]
  })

  managed_policy_arns = [aws_iam_policy.eks-efs-csi-policy.arn]
  tags = {
    owner   = "Your Name"
    creator = "Terraform"
    cluster = var.sc_eks_cluster_name
  }
}

resource "aws_iam_role" "eks-ebs-csi-role" {
  name = "EBS-CSI-Driver-Role-${var.sc_eks_cluster_name}"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRoleWithWebIdentity"
        Effect    = "Allow"
        Sid       = ""
        Principal = {
          "Federated": "arn:aws:iam::${var.aws_account_number}:oidc-provider/${substr(data.aws_eks_cluster.this.identity[0].oidc[0].issuer, 8, -1)}"
        }
        Condition = {
          StringEquals = {
            "${substr(data.aws_eks_cluster.this.identity[0].oidc[0].issuer, 8, -1)}:aud" = "sts.amazonaws.com"
          }
        }
      },
    ]
  })

  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"]
  tags = {
    owner   = "Your Name"
    creator = "Terraform"
    cluster = var.sc_eks_cluster_name
  }
}