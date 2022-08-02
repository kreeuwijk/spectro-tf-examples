data "aws_availability_zones" "available" {}

data "aws_vpc" "cluster" {
  count = data.external.get_cluster_state.result.state == "1" ? 1 : 0
  tags  = {
    Name = "${var.sc_eks_cluster_name}-vpc"
  }
}

data "aws_subnets" "private" {
  count = data.external.get_cluster_state.result.state == "1" ? 1 : 0
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.cluster[count.index].id]
  }
  tags = {
    "sigs.k8s.io/cluster-api-provider-aws/role" = "private"
  }
}

data "aws_security_group" "eks" {
  count  = data.external.get_cluster_state.result.state == "1" ? 1 : 0
  vpc_id = data.aws_vpc.cluster[count.index].id
  tags   = {
    "aws:eks:cluster-name" = var.sc_eks_cluster_name
  }
}

resource "aws_efs_file_system" "efs" {
  count            = data.external.get_cluster_state.result.state == "1" ? 1 : 0
  creation_token   = "efs"
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  encrypted        = "true"
  tags             = {
    Name = "${var.sc_eks_cluster_name}-EFS"
  }
}

resource "aws_efs_mount_target" "efs-mt" {
  count           = length(data.aws_subnets.private) > 0 ? length(data.aws_subnets.private[0].ids) * (data.external.get_cluster_state.result.state == "1" ? 1 : 0) : 0
  file_system_id  = aws_efs_file_system.efs[0].id
  subnet_id       = data.aws_subnets.private[0].ids[count.index]
  security_groups = [data.aws_security_group.eks[0].id]
}