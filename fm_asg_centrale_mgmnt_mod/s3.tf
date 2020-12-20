resource "aws_s3_bucket" "dm_mgmnt_bucket_res" {
  bucket = var.bucket_name
  acl    = "bucket-owner-full-control"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.dm_kms_res.id
        sse_algorithm     = "aws:kms"
      }
    }
  }

  force_destroy = var.bucket_force_destroy

  versioning {
    enabled = var.bucket_versioning
  }

  lifecycle_rule {
    id      = "log"
    enabled = var.log_auto_clean

    prefix = "logs/"

    tags = {
      rule      = "log"
      autoclean = var.log_auto_clean
    }

    transition {
      days          = var.log_standard_ia_days
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = var.log_glacier_days
      storage_class = "GLACIER"
    }

    expiration {
      days = var.log_expiry_days
    }
  }

  tags = merge(var.tags)
}

resource "aws_s3_bucket_object" "bucket_public_keys_readme" {
  bucket  = aws_s3_bucket.dm_mgmnt_bucket_res.id
  key     = "public-keys/README.txt"
  content = "Drop here the ssh public keys of the instances you want to control"
}