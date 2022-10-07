resource "aws_efs_file_system" "efs" {
  creation_token   = "efs"
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  encrypted        = "true"
  tags = {
    Name = "${var.name}-EFS"
  }
}

resource "aws_efs_mount_target" "efs-mt" {
  count           = length(var.azs)
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = data.aws_subnets.private.ids[count.index]
  security_groups = [data.aws_security_group.aws.id]
}
