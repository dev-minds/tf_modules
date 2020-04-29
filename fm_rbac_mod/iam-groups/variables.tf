variable "grp_name" {
  description = "Specify group name"
  type        = string
  default     = "team_london"
}

variable "group_users" {
  description = "Specify IAM users to have"
  type        = list(string)
  default     = ["peter"]
}

variable "assumable_roles" {
  description = "List of IAM roles ARNs which can be assumed by the group"
  type        = list(string)
  default     = ["OrganizationAccountAccessRole"]
}

variable "policy_name" {
  description = "Name of IAM policy and IAM group"
  type        = string
  default     = "GroupSwitchAcctPol"   
}