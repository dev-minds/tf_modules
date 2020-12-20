variable "cidr_block" {
  default     = ""
  description = "Ip Range for VPC"
}

variable "vpc_name" {
  default     = ""
  description = "Specify VPCname"
}

variable "availability_zones" {
  description = "Specify availability zones"
  type        = "list"
}

variable "profile_name" {
  default     = ""
  description = "Specify profile name"
}

variable "aws_region" {
  default     = "eu-west-1"
  description = "Specify Region"
}

variable "ami_id" {
  default = ""
}

variable "name_tag" {
  default = ""
}


