resource "aws_security_group" "dm_mgmnt_pub_sg_res" {
  description = "Define external ssh access"
  name        = "${local.name_prefix}-host"
  vpc_id      = var.vpc_id

  tags = merge(var.tags)
}

resource "aws_security_group_rule" "dm_ingress_mgmnt_res" {
  description = "Incoming traffic to MGMNT host"
  type        = "ingress"
  from_port   = var.public_ssh_port
  to_port     = var.public_ssh_port
  protocol    = "TCP"
  cidr_blocks = concat(data.aws_subnet.subnets.*.cidr_block, var.cidrs)

  security_group_id = aws_security_group.dm_mgmnt_pub_sg_res.id
}

resource "aws_security_group_rule" "dm_egress_mgmnt_res" {
  description = "Outgoing traffic from bastion to instances"
  type        = "egress"
  from_port   = "0"
  to_port     = "65535"
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.dm_mgmnt_pub_sg_res.id
}

resource "aws_security_group" "dm_mgmnt_priv_sg_res" {
  description = "Enable SSH access to the Private instances via SSH port"
  name        = "${local.name_prefix}-priv-instances"
  vpc_id      = var.vpc_id

  tags = merge(var.tags)
}

resource "aws_security_group_rule" "dm_priv_sg_res" {
  description = "Incoming traffic from bastion"
  type        = "ingress"
  from_port   = var.public_ssh_port
  to_port     = var.public_ssh_port
  protocol    = "TCP"

  source_security_group_id = aws_security_group.dm_mgmnt_pub_sg_res.id
  security_group_id        = aws_security_group.dm_mgmnt_priv_sg_res.id
}