# All variables 
variable "ip_range" {
  description = "Specify cidr block for your VPC"
  type        = string
  default     = ""
}

variable "inst_tenancy" {
  description = "Specify ec2 instances tenancy"
  type        = string
  default     = "default"
}

variable "name_tag" {
  description = "SPecify Name tag fot vpc"
  type        = string
  default     = ""
}

variable "dns_support" {
  description = "Specify to enable dns-support"
  type        = bool
  default     = ""
}

variable "dns_hostn" {
  description = "Specify to enable dns_hostn"
  type        = bool
  default     = ""
}

variable "pub_ip_range" {
  description = "Specify public ip ranges"
  type        = list
  default     = []
}

variable "pub_azs" {
  description = "Specify which public availability zones"
  type        = list
  default     = []
}

variable "priv_ip_range" {
  description = "Specify private ip ranges"
  type        = list
  default     = []
}

variable "priv_azs" {
  description = "Specify which private availability zones"
  type        = list
  default     = []
}

variable "enabled_nat_gateway" {
  description = "Set to false to prevent the module from creating NAT Gateway resources."
  default     = true
  type        = string
}

variable "enabled_single_nat_gateway" {
  description = "Set to true to create single NAT Gateway resource."
  default     = false
  type        = string
}