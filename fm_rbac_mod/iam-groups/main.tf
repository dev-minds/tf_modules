provider "aws" {
  region = "eu-west-1"
}

resource "aws_iam_policy" "grp_assume_pol_res" {
  name        = "GroupSwitchAcctPol"
  description = "Allows to assume role in another AWS account"
  policy      = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_group_policy_attachment" "grp_assume_pol_attach_res" {
  group      = aws_iam_group.dm_grp_res.id
  policy_arn = aws_iam_policy.grp_assume_pol_res.id
}


resource "aws_iam_group" "dm_grp_res" {
  name = var.grp_name
}

resource "aws_iam_group_membership" "dm_grp_member_res" {
  // count = length(var.grp_users) > 0 ? 1 : 0
  group = var.grp_name
  name  = var.grp_name
  users = var.grp_users
}


resource "aws_iam_policy" "iam_self_management" {
  name = "GroupBasePermPol"
  //name_prefix = var.iam_self_management_policy_name_prefix
  policy = data.aws_iam_policy_document.iam_self_management.json
}

resource "aws_iam_group_policy_attachment" "iam_self_management" {
  group      = var.grp_name
  policy_arn = aws_iam_policy.iam_self_management.arn
}

// locals {
//   group_name = element(concat(aws_iam_group.dm_grp_res.*.id, [var.grp_name]), 0)
// }
