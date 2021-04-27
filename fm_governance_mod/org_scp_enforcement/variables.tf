# Variables
variable "associate-acct-ids" {
  description = "Target ids (AWS Account or Organizational Unit) to attach an SCP denying the ability to leave the AWS Organization"
  type        = list(string)
  default     = ["023451010066", "984463041714"]
}

variable "allowed_regions" {
  description = "AWS Regions allowed for use (for use with the restrict regions SCP)"
  type        = list(string)
  default     = ["eu-west-1"]
}

variable "default-scp-rule-name" {
  description = "default scp rule"
  type        = string
  default     = "deny-leaving-orgs"
}

variable "restrict-tagpolicy-name" {
  description = "default scp rule"
  type        = string
  default     = "GlobalTagging"
}

variable "enforce-scp-rule-name" {
  description = "default scp rule"
  type        = string
  default     = "Enforce Tagss"
}


