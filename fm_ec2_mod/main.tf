variable "ami_name" { default = "" }
variable "instance_type" { default = "" }
variable "target_keypairs" { default = "" }
variable "target_subnet" { default = "" }
variable "vpc_id" { default = "" }

data "aws_ami" "this_ami" {
  # executable_users = ["self"]
  most_recent      = true
  # name_regex       = "^${var.ami_name}"
  owners           = ["self"]

  filter {
    name   = "name"
    values = ["Base*"]
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

resource "aws_instance" "inst_res" {
  ami                    = data.aws_ami.this_ami.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.sg_res.id]
  key_name               = var.target_keypairs
  subnet_id              = var.target_subnet

  tags = {
    Name = "Test-Server"
  }
}

resource "aws_security_group" "sg_res" {
  name_prefix = "SG"
  description = "Ports"
  vpc_id      = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "TestGroup"
  }
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
