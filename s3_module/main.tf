resource "aws_s3_bucket" "dm_s3_mod_res" {
  bucket = "${var.bucket_name}"
  acl    = "${var.bucket_acl}"

  tags = {
    Name        = "${var.bucket_tag}"
    Environment = "${var.bucket_acct}"
  }
}