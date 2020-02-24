output "bucket_name" {
  description = "S3 bucket names" 
  value       = "${aws_s3_bucket.dm_s3_mod_res}"
}

