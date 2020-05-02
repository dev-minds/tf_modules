data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    resources = [
      "arn:aws:iam::984463041714:role/OrganizationAccountAccessRole",
      "arn:aws:iam::023451010066:role/OrganizationAccountAccessRole"
    ]
  }
}

data "aws_caller_identity" "current" {
  count = var.aws_account_id == "" ? 1 : 0
}

locals {
  aws_account_id = element(
    concat(
      data.aws_caller_identity.current.*.account_id,
      [var.aws_account_id],
    ),
    0,
  )
}


data "aws_iam_policy_document" "iam_self_management" {
  statement {
    sid    = "AllowSelfManagement"
    effect = "Allow"
    actions = [
      "iam:ChangePassword",
      "iam:CreateVirtualMFADevice",
    ]
    resources = [
      "arn:aws:iam::${local.aws_account_id}:user/*/$${aws:username}",
    ]
  }

  statement {
    sid = "AllowIamService"
    actions = [
      "iam:Get*",
      "iam:List*",
    ]
    resources = ["*"]
    effect    = "Allow"
  }

  statement {
    sid = "AllowS3"
    actions = [
      "s3:*",
    ]
    resources = ["*"]
    effect    = "Allow"
  }

}