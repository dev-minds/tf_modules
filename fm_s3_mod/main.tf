# Main resource definition 

resource "aws_s3_bucket" "dm_s3_mod_res" {
    count = var.create_bucket_toggle ? 1 : 0

    bucket = var.bucket   
}
