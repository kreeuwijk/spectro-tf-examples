data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_eks_cluster" "this" {
  name = spectrocloud_cluster_eks.cluster.name
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_eks_cluster.this.vpc_config[0].vpc_id]
  }
  tags = {
    "sigs.k8s.io/cluster-api-provider-aws/role" = "private"
  }
}

data "aws_security_group" "eks" {
  vpc_id = data.aws_eks_cluster.this.vpc_config[0].vpc_id
  tags = {
    "aws:eks:cluster-name" = var.sc_eks_cluster_name
  }
}

resource "aws_efs_file_system" "efs" {
  creation_token   = "efs"
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  encrypted        = "true"
  tags = {
    Name = "${var.sc_eks_cluster_name}-EFS"
  }
}

resource "aws_efs_mount_target" "efs-mt" {
  count           = length(data.aws_availability_zones.available.names)
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = data.aws_subnets.private.ids[count.index]
  security_groups = [data.aws_security_group.eks.id]
}
