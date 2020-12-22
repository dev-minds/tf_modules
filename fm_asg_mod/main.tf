########################################
# Auto Scaling Group | EC2 gatekeeper 
# - Launch Configuration 
# - Template file 
# - Autoscaling Group 
# - Security Grup 
# - Sec G rules 
# - Optional 
#########################################

provider "aws" {
  region  = "eu-west-1"
  profile = "admin_master"
}

variable "host_prefix" { default = "app_fe" }
variable "ami_name" { default = "Base*" }
variable "instance_type" { default = "t2.micro" }
variable "key_pair" { default = "centrale-keys" }
variable "subnetst" { default = "subnet-0aefdec870f6ba7c6" }
variable "billing_code_tag" { default = "1234" }
variable "env_tag" { default = "app-server" }
variable "server_port" { default = "22" }
variable "elb_port" { default = "80" }
variable "tier_name" { default = "fe" }



locals {
  common_tags = {
    BillingCodes = var.billing_code_tag
    EnvLocals    = var.env_tag
  }
}

data "aws_availability_zones" "all" {}
data "aws_ami" "this_ami" {
  most_recent = true
  owners      = ["self"]

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

#########################################
# POST BOOT SCRIPT 
#########################################
data "template_file" "dm_custom_userdata_ds" {
  template = "${file("${path.module}/templates/userdata.sh")}"
}

data "template_cloudinit_config" "dm_userd_cloud_ds" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    content      = "${data.template_file.dm_custom_userdata_ds.rendered}"
  }
}

######
resource "aws_security_group" "this_sv_sg" {
  name = "asg-servers-ports"
  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "this_elb_sg" {
  name = "asg-elb-ports"
  # Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Inbound HTTP from anywhere
  ingress {
    from_port   = var.elb_port
    to_port     = var.elb_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

###### 
resource "aws_launch_configuration" "this_lc_res" {
  name_prefix                 = var.host_prefix
  image_id                    = data.aws_ami.this_ami.id
  instance_type               = var.instance_type
  key_name                    = var.key_pair
  enable_monitoring           = true
  security_groups             = [aws_security_group.this_sv_sg.id]
  associate_public_ip_address = true
  user_data                   = data.template_cloudinit_config.dm_userd_cloud_ds.rendered

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "dm_bastion_asg_res" {
  name                 = "${aws_launch_configuration.this_lc_res.name}-asg"
  min_size             = "0"
  max_size             = "0"
  desired_capacity     = "1"
  health_check_type    = "ELB"
  launch_configuration = aws_launch_configuration.this_lc_res.name
  vpc_zone_identifier  = [var.subnetst]

  # vpc_zone_identifier  = "${aws_subnet.dm_sn_pub_res.*.id}"
  # health_check_type    = "E0C2"
  # tags = merge(
  #   local.common_tags, { Name = "${var.env_tag}-server" }
  # )

  lifecycle {
    create_before_destroy = true
  }
}
`

resource "aws_elb" "this_elb" {
  name               = "${var.tier_name}-tier-lb"
  security_groups    = [aws_security_group.this_elb_sg.id]
  availability_zones = data.aws_availability_zones.all.names

  health_check {
    target              = "HTTP:${var.server_port}/"
    interval            = 30
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  # Adding a listener for incoming HTTP requests.
  listener {
    lb_port           = var.elb_port
    lb_protocol       = "http"
    instance_port     = var.server_port
    instance_protocol = "http"
  }
}

output "elb_dns_name" {
  value = aws_elb.this_elb.dns_name
}