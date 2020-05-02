variable "grp_name" {
  description = "Specify group name"
  type        = string
  default     = ""
}

variable "grp_users" {
  description = "Specify IAM users to have"
  type        = list(string)
  default     = []
}

variable "aws_account_id" {
  description = "Keeping this as centrale account for all groups"
  type        = string
  default     = "658951324167"
}