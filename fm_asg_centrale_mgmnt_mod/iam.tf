data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "mgmnt_role" {
  name               = "ManagmentNodeRole"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "base_role_policy" {
  statement {
    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl"
    ]
    resources = ["${aws_s3_bucket.dm_mgmnt_bucket_res.arn}/logs/*"]
  }

  statement {
    actions = [
      "s3:GetObject"
    ]
    resources = ["${aws_s3_bucket.dm_mgmnt_bucket_res.arn}/public-keys/*"]
  }

  statement {
    actions = [
      "s3:ListBucket"
    ]
    resources = ["${aws_s3_bucket.dm_mgmnt_bucket_res.arn}"]

    condition {
      test     = "ForAnyValue:StringEquals"
      values   = ["public-keys/"]
      variable = "s3:prefix"
    }
  }

  statement {
    actions = [

      "kms:Encrypt",
      "kms:Decrypt"
    ]
    resources = [aws_kms_key.dm_kms_res.arn]
  }

}

resource "aws_iam_instance_profile" "mgmnt_host_profile" {
  role = aws_iam_role.mgmnt_role.name
  path = "/"
}