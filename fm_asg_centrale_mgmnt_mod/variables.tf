variable "aws_region" {
  description = "Specify target region"
  type        = string
  default     = "eu-west-1"
}

variable "tags" {
  description = "Specify tags"
  type        = map(string)
  default     = {}
}

variable "bucket_name" {
  description = "Specify bucket name"
  type        = string
  default     = "bastion-test-works-2021-april"
}

variable "bucket_force_destroy" {
  description = "Specify to totally destroy bucket"
  default     = true
}

variable "bucket_versioning" {
  description = "Specify bucket versioning feature"
  default     = true
}

variable "log_auto_clean" {
  description = "Specify to auto clean bucket for lifecycle"
  default     = true
}

variable "log_standard_ia_days" {
  description = "Specify bucket logs retentio period in days before Infrequent Access-IA "
  default     = "30"
}

variable "log_glacier_days" {
  description = "Specify number of days before logs moves to glacie"
  default     = "60"
}

variable "log_expiry_days" {
  description = "Specify number of days before logs expire"
  default     = "90"
}

# SG Vars 
variable "vpc_id" {
  description = "Specify Target Vpc: Will default to management vpc"
  type        = string
  default     = "vpc-04c20ad265bf4b667"
}

variable "public_ssh_port" {
  description = "Specify Target ssh port"
  type        = string
  default     = "22"
}

variable "tg_subnets" {
  description = "Specify target subnets"
  type        = list(string)
  default     = ["subnet-0ed7ee591cfecf7a1"]
}

variable "mgmnt_lt_name" {
  description = "Specify prefix name for LT"
  type        = string
  default     = "dm_asg"
}

variable "cidrs" {
  description = "Specify a cidr"
  type        = list(string)
  default     = ["0.0.0.0/0", ]
}

variable "ami_id" {
  description = "Specify AMI or not"
  type        = string
  default     = ""
}

# ASG VARS 
variable "associate_public_ip_address" {
  description = "Specify to give public addr"
  default     = "true"
}

variable "host_key_pair" {
  description = "Specify key pairs"
  type        = string
  default     = "centrale-keys"
}

variable "extra_user_data_content" {
  description = "Additional scripting to pass to the bastion host. For example, this can include installing postgresql for the `psql` command."
  type        = string
  default     = ""
}

variable "allow_ssh_commands" {
  description = "Allows the SSH user to execute one-off commands. Pass 'True' to enable. Warning: These commands are not logged and increase the vulnerability of the system. Use at your own discretion."
  type        = string
  default     = "true"
}

variable "mgmnt_launch_template_name" {
  description = "Specify template name "
  type        = string
  default     = "dm_lt"
}

variable "mgmnt_instance_count" {
  default = 1
}

variable "auto_scaling_group_subnets" {
  type        = list(string)
  description = "List of subnet were the Auto Scalling Group will deploy the instances"
  default     = ["subnet-0ed7ee591cfecf7a1"]
}