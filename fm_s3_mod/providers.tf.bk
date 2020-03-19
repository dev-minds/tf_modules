provider "aws" {
  #   profile = "${var.profile_name}"
  region  = "eu-west-1"
  version = "~> 2.7"
}

terraform {
  required_version = ">= 0.12.12"

  backend "s3" {
    bucket  = "dm-vpc-states"
    key     = "modules_tst/terraform.tfstate"
    region  = "eu-west-1"
    encrypt = "true"
  }
}
