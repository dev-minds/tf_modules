# Main resource definition 

resource "aws_s3_bucket" "dm_s3_mod_res" {
  count = var.create_bucket_toggle ? 1 : 0
  // bucket_prefix       = var.bucket_pref
  // count               = length(var.bucket_name)
  bucket              = var.bucket_name
  acl                 = var.access_level
  tags                = var.map_tags
  force_destroy       = var.force_destroy
  acceleration_status = var.acceleration_status
  region              = var.region
  request_payer       = var.request_payer

  dynamic "cors_rule" {
    for_each = length(keys(var.cors_rule)) == 0 ? [] : [var.cors_rule]

    content {
      allowed_methods = cors_rule.value.allowed_methods
      allowed_origins = cors_rule.values.allowed_origins
    }
  }

  dynamic "versioning" {
    for_each = length(keys(var.versioning)) == 0 ? [] : [var.versioning]

    content {
      enabled    = lookup(versioning.value, "enabled", null)
      mfa_delete = lookup(versioning.value, "mfa_delete", null)
    }
  }

  //   dynamic "logging" {
  //     for_each = length(keys(var.logging)) == 0 ? [] : [var.logging]

  //     content {
  //       target_bucket = logging.value.target_bucket
  //       target_prefix = lookup(logging.value, "target_prefix", null)
  //     }
  //   }
  // }

}

resource "aws_s3_bucket_policy" "dm_s3_mode_base_pol_res" {
  count  = var.create_bucket_toggle && var.attach_policy_toggle ? 1 : 0
  bucket = aws_s3_bucket.dm_s3_mod_res[0].id
  policy = var.policy
}
