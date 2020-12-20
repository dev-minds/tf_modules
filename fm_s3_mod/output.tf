# Main output definitions 
output "s3_bucket_id" {
  description = "Outupe bucket name"
  value       = element(concat(aws_s3_bucket.dm_s3_mod_res.*.id, list("")), 0)
}