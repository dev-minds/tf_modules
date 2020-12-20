resource "aws_kms_key" "dm_kms_res" {
  tags = merge(var.tags)
}

resource "aws_kms_alias" "dm_kms_alias_res" {
  name          = "alias/${var.bucket_name}"
  target_key_id = aws_kms_key.dm_kms_res.arn
}