provider "aws" {
  profile = "${var.profile_name}"
  region  = "${var.aws_region}"
  version = "~> 2.7"
}

terraform {
  required_version = ">= 0.12.12"

  backend "s3" {
    bucket  = "dm-vpc-states"
    key     = "dm_infra/terraform.tfstate"
    region  = "eu-west-1"
    encrypt = "true"
  }
}


