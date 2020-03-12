# Main variable definitions 
variable "region" {
  description = "Specify region"
  type        = string
  default     = "eu-west-1"
}

variable "create_bucket_toggle" {
  description = "Specify toggle to create bucket or not to create"
  type        = bool
  default     = true
}

variable "bucket_name" {
  description = "Specify unique bucket name. If ommitted, a random name will be generated"
  type        = string
  default     = ""
}

variable "bucket_prefix" {
  description = "Specific custom prefix for bucket"
  type        = string
  default     = "pref"
}

variable "access_level" {
  description = "Specify resource layer access level"
  type        = string
  default     = "private"
}

variable "map_tags" {
  description = "Specify custom tags fo tag mapping"
  type        = map(string)
  default     = {}
}

variable "force_destroy" {
  description = "Specify to destroy objects from bucket before destroying bucket "
  type        = bool
  default     = false
}

variable "acceleration_status" {
  description = "Specify accelerate config of existing bucket"
  type        = string
  default     = null
}

variable "request_payer" {
  description = "Specify who bears bucket resource cost"
  type        = string
  default     = null
}

variable "cors_rule" {
  description = "Specify rules of Cross-Origin Resource Sharing"
  type        = any
  default     = {}
}

variable "versioning" {
  description = "Specify to enable versioning or not"
  type        = map(string)
  default = {
    enabled = true
  }
}

variable "logging" {
  description = "Map containing access bucket logging configuration."
  type        = map(string)
  default = {
    enabled = false
  }
}

variable "policy" {
  description = "(Optional) A valid bucket policy JSON document. Note that if the policy document is not specific enough (but still valid), Terraform may view the policy as constantly changing in a terraform plan. In this case, please make sure you use the verbose/specific version of the policy. For more information about building AWS IAM policy documents with Terraform, see the AWS IAM Policy Document Guide."
  type        = string
  default     = null
}

variable "attach_policy_toggle" {
  description = "Controls if S3 bucket should have bucket policy attached (set to `true` to use value of `policy` as bucket policy)"
  type        = bool
  default     = false
}