resource "aws_s3_bucket" "dm_s3_mod_res" {
  count  = "${var.create_bucket ? 1 : 0}"
  bucket = "${var.bucket_name}"
  acl    = "${var.bucket_acl}"

  tags = {
    Name        = "${var.bucket_tag}"
    Environment = "${var.bucket_acct}"
  }
}

# resource "aws_s3_bucket_public_access_block" "dm_s3_public_access_res" {
#   depends_on = ["${aws_s3_bucket.dm_s3_mod_res}"]

# }
