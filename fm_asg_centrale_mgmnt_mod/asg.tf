resource "aws_launch_template" "dm_mgmnt_lt_res" {
  name_prefix   = local.name_prefix
  image_id      = var.ami_id != "" ? var.ami_id : data.aws_ami.dm_base_ami_choice.id
  instance_type = "t2.xlarge"
  monitoring {
    enabled = true
  }
  network_interfaces {
    associate_public_ip_address = var.associate_public_ip_address
    security_groups             = [aws_security_group.dm_mgmnt_pub_sg_res.id]
    delete_on_termination       = true
  }
  iam_instance_profile {
    name = aws_iam_instance_profile.mgmnt_host_profile.name
  }
  key_name = var.host_key_pair

  user_data = base64encode(data.template_file.user_data.rendered)

  tag_specifications {
    resource_type = "instance"
    tags          = merge(map("Name", var.mgmnt_launch_template_name), merge(var.tags))
  }

  tag_specifications {
    resource_type = "volume"
    tags          = merge(map("Name", var.mgmnt_launch_template_name), merge(var.tags))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "bastion_auto_scaling_group" {
  name_prefix = "ASG-${local.name_prefix}"
  launch_template {
    id      = aws_launch_template.dm_mgmnt_lt_res.id
    version = "$Latest"
  }
  max_size         = var.mgmnt_instance_count
  min_size         = var.mgmnt_instance_count
  desired_capacity = var.mgmnt_instance_count

  vpc_zone_identifier = var.auto_scaling_group_subnets

  default_cooldown          = 180
  health_check_grace_period = 180
  health_check_type         = "EC2"

  //   target_group_arns = [
  //     aws_lb_target_group.bastion_lb_target_group.arn,
  //   ]

  termination_policies = [
    "OldestLaunchConfiguration",
  ]

  //   tags = concat(
  //     list(map("key", "Name", "value", "ASG-${local.name_prefix}", "propagate_at_launch", true)),
  //     local.tags_asg_format
  //   )

  lifecycle {
    create_before_destroy = true
  }
}