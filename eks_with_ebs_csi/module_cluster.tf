module "example-cluster" {
  source = "./modules/palette_eks_cluster"
  name   = "example-eks-with-ebs"

  # AWS cloudaccount in Palette to use
  cloudaccount = "aws-spectro"

  # AWS region and SSH key to use
  region = var.aws_region
  sshkey = "your_AWS_ssh_key_name"

  # Cluster size: worker pool
  worker_min           = 1
  worker_count         = 2
  worker_max           = 3
  worker_instance_type = "t3.large"
  worker_disk_size_gb  = 60

}