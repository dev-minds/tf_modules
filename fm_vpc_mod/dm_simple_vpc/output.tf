output "vpc_id_otp" {
  description = "Fetch VPC ID "
  value       = concat(aws_vpc.dm_vpc_res.*.id, [""])[0]
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.private.*.id
}