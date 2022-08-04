data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_vpc" "this" {
  tags  = {
    Name = "${spectrocloud_cluster_aws.cluster.name}-vpc"
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.this.id]
  }
  tags = {
    "sigs.k8s.io/cluster-api-provider-aws/role" = "private"
  }
}

data "aws_security_group" "aws" {
  vpc_id = data.aws_vpc.this.id
  name = "default"
}

resource "aws_efs_file_system" "efs" {
  creation_token   = "efs"
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  encrypted        = "true"
  tags = {
    Name = "${var.sc_aws_cluster_name}-EFS"
  }
}

resource "aws_efs_mount_target" "efs-mt" {
  count           = length(data.aws_availability_zones.available.names)
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = data.aws_subnets.private.ids[count.index]
  security_groups = [data.aws_security_group.aws.id]
}
