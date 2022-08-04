# spectro-tf-examples
Terraform examples for Spectrocloud Palette

## aws_with_ebs_and_efs_csi
Demonstrates deployment of a Kubernetes cluster on AWS EC2, including auto-configuration of AWS EBS for block storage PVs and AWS EFS for file storage PVs.

The Terraform run will create the following resources:
* An IAM Policy for the EFS CSI driver
* An IAM Role attachment, attaching the EFS CSI driver policy to the `nodes.cluster-api-provider-aws.sigs.k8s.io` IAM role
* An IAM Role attachment, attaching the AWS-owned EBS CSI driver policy to the `nodes.cluster-api-provider-aws.sigs.k8s.io` IAM role
* An AWS EFS filesystem
* A Kubernetes cluster on AWS EC2 (1 master node, 2 worker nodes), using Spectrocloud Palette for deployment
* Three EFS mount targets, in the private subnets that were created by Palette's Kubernetes cluster deployment

To ensure the EFS and EBS CSIs are ready immediately after cluster deployment, Terraform will:
* inject the Filesystem ID of the created EFS filesystem into the `cs-aws-efs` pack

## eks_with_ebs_and_efs_csi
Demonstrates deployment of a AWS EKS cluster, including auto-configuration of AWS EBS for block storage PVs and AWS EFS for file storage PVs.

The Terraform run will create the following resources:
* An IAM Policy for the EFS CSI driver
* An IAM Role for the EKS cluster, attaching the EFS CSI driver policy to this role and allowing access to the EKS cluster's OIDC identity
* An IAM Role for the EKS cluster, attaching the AWS-owned EBS CSI driver policy to this role and allowing access to the EKS cluster's OIDC identity
* An AWS EFS filesystem
* An EKS cluster (2 worker nodes), using Spectrocloud Palette for deployment
* Three EFS mount targets, in the private subnets that were created by Palette's Kubernetes cluster deployment

To ensure the EFS and EBS CSIs are ready immediately after cluster deployment, Terraform will:
* inject the Filesystem ID of the created EFS filesystem into the `cs-aws-efs` pack
* inject the EKS role ARN that contains the IAM Policy for the EFS CSI driver into an annotation for the EFS CSI ServiceAccount
* inject the EKS role ARN that contains the IAM Policy for the EBS CSI driver into an annotation for the EBS CSI ServiceAccount
