output "bucket_name" {
  description = "S3 bucket names" 
  value       = "${aws_s3bucket.dm_s3_mod_res}"
}

