variable "ami_name" { default = "" }
variable "instance_type" { default = "" }
variable "target_keypairs" { default = "" }
variable "target_subnet" { default = "" }
variable "vpc_id" { default = "" }
variable "billing_code_tag" { default = "" }
variable "env_tag" { default = "" }
variable "instance_count" { default = "" }

locals {
  # bucket_name = "${var.bket_name_prefix}-${var.env_tag}-${random_integer.this_random_vals.result}"
  common_tags = {
    BillingCodes = var.billing_code_tag
    EnvLocals    = var.env_tag
  }
}

data "aws_availability_zones" "this_ds_azs" {}
data "aws_ami" "this_ami" {
  most_recent      = true
  owners           = ["self"]

  filter {
    name   = "name"
    values = [var.ami_name]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "random_integer" "this_random_vals" {
  min = 1000000
  max = 9999900
}

resource "aws_instance" "inst_res" {
  count                  = var.instance_count
  ami                    = data.aws_ami.this_ami.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.sg_res.id]
  key_name               = var.target_keypairs
  subnet_id              = var.target_subnet

  tags = merge(
    local.common_tags, { Name = "${var.env_tag}-server" }
  )
}

resource "aws_security_group" "sg_res" {
  name_prefix = "SG"
  description = "Ports"
  vpc_id      = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    local.common_tags, { Name = "${var.env_tag}-server" }
  )
}

resource "aws_security_group_rule" "sg_ssh_res" {
  type              = "ingress"
  from_port         = "22"
  to_port           = "22"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg_res.id
}

resource "aws_security_group_rule" "egress_res" {
  type              = "egress"
  from_port         = "0"
  to_port           = "0"
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg_res.id
}
