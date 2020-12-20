output "out_bucket_name" {
  description = "S3 bucket names"
  value       = "${join(" ", aws_s3_bucket.dm_s3_mod_res.*.id)}"
}

