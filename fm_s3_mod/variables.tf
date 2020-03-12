# Main variable definitions 
variable "create_bucket_toggle" {
    description = "Toggle to create bucket or not to create"
    type        = bool 
    default     = true 
}

variable "bucket" {
    description = "Your unique bucket name. If ommitted, a random name will be generated"
    type        = string 
    default     = null 
}

