data "aws_subnet" "subnets" {
  count = length(var.tg_subnets)
  id    = var.tg_subnets[count.index]
}

data "aws_ami" "dm_base_ami_choice" {
  most_recent = true
  owners      = ["self"]
  name_regex  = "^BaseCentOs7Image*"

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}