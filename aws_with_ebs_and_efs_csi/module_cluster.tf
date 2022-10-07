module "example-cluster" {
  source = "./modules/palette_aws_efs_cluster"
  name   = "example-aws-with-ebs-and-efs"

  # AWS cloudaccount in Palette to use
  cloudaccount = "aws-spectro"

  # AWS region and SSH key to use
  region = var.aws_region
  azs    = ["${var.aws_region}a","${var.aws_region}b","${var.aws_region}c"]
  sshkey = "your_AWS_ssh_key_name"

  # Cluster size: master pool
  master_count         = 1
  master_instance_type = "t3.large"
  master_disk_size_gb  = 60

  # Cluster size: worker pool
  worker_count         = 2
  worker_instance_type = "t3.large"
  worker_disk_size_gb  = 60

}

resource "aws_iam_role_policy_attachment" "attach-aws-ebs-csi-policy" {
  role       = "nodes.cluster-api-provider-aws.sigs.k8s.io"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}