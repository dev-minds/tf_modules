resource "aws_s3_bucket" "dm_s3_mod_res" {
  count  = "${var.create_bucket ? 1 : 0}"
  bucket = "${var.bucket_name}"
  acl    = "${var.bucket_acl}"

  tags = {
    Name        = "${var.bucket_tag}"
    Environment = "${var.bucket_acct}"
  }
}


resource "aws_s3_bucket_policy" "dm_s3_private_acc_res" {
  count = "${var.public_access != true && var.create_bucket ? 1 : 0}"
  bucket = "${aws_s3_bucket.dm_s3_mod_res[0].id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Action": ["s3:*"],
      "Effect": "Allow",
      "Resource": ["arn:aws:s3:::${var.bucket_name}",
                   "arn:aws:s3:::${var.bucket_name}/*"],
      "Principal": "*"
    }
  ]
}
EOF
}


resource "aws_s3_bucket_policy" "dm_s3_public_acc_res" {
  count  = "${var.public_access && var.create_bucket ? 1 : 0}"
  bucket = "${aws_s3_bucket.dm_s3_mod_res[0].id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Action": ["s3:*"],
      "Effect": "Allow",
      "Resource": ["arn:aws:s3:::${var.bucket_name}",
                   "arn:aws:s3:::${var.bucket_name}/*"],
      "Principal": "*"
    },
    {
      "Sid": "",
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": ["arn:aws:s3:::${var.bucket_name}",
                   "arn:aws:s3:::${var.bucket_name}/*"],
      "Principal": {
        "AWS": "*"
      }
    }
  ]
}
EOF
}