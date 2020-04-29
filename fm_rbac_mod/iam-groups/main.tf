locals {
  group_name = element(concat(aws_iam_group.dm_grp_res.*.id, [var.grp_name]), 0)
}


data "aws_iam_policy_document" "assume_role" {
  statement {
    effect    = "Allow"
    actions   = ["sts:AssumeRole"]
    resources = [
        "arn:aws:iam::984463041714:role/OrganizationAccountAccessRole",
        "arn:aws:iam::023451010066:role/OrganizationAccountAccessRole"
    ]
  }
}


resource "aws_iam_policy" "this" {
  name        = var.policy_name
  description = "Allows to assume role in another AWS account"
  policy      = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_group" "dm_grp_res" {
  name = var.grp_name
}

resource "aws_iam_group_membership" "dm_grp_member_res" {
  count = length(var.group_users) > 0 ? 1 : 0
  group = local.group_name
  name  = var.grp_name
  users = var.group_users
}

resource "aws_iam_group_policy_attachment" "this" {
  group      = aws_iam_group.dm_grp_res.id
  policy_arn = aws_iam_policy.this.id
}
