#######################################
# Fetch VPC resources
# Below list of reference possible fetchable resources 
# https://github.com/terraform-aws-modules/terraform-aws-vpc/blob/master/outputs.tf
# #################################################################################
output "vpc_id_otp" {
  description = "Fetch VPC ID "
  value       = concat(aws_vpc.dm_vpc_res.*.id, [""])[0]
}

output "vpc_cidr_otp" {
  description = "Fetch VPC cidr"
  value       = concat(aws_vpc.dm_vpc_res.*.cidr_block, [""])[0]
}


output "pub_sn_id_otp" {
  value = aws_subnet.dm_sn_pub_res.*.id
}

output "priv_sn_id_otp" {
  value = aws_subnet.dm_sn_priv_res.*.id
}

output "pub_sn_cidr_otp" {
  value = aws_subnet.dm_sn_pub_res.*.cidr_block
}

output "priv_sn_cidr_otp" {
  value = aws_subnet.dm_sn_priv_res.*.cidr_block
}


