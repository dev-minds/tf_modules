provider "aws" {
  #   profile = "${var.profile_name}"
  region  = "eu-west-1"
  version = "~> 2.7"
}

terraform {
  required_version = ">= 0.12.12"

  backend "s3" {
    bucket  = "centrale-accts-org-store"
    key     = "bastion_keys/terraform.tfstate"
    region  = "eu-west-1"
    encrypt = "true"
  }
}
