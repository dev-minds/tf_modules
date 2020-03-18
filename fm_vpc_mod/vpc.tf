#########################################################
# VPC setup for our DC 
# https://www.terraform.io/docs/providers/aws/r/ami.html
#########################################################
resource "aws_vpc" "dm_vpc_res" {
  cidr_block = "${var.cidr_block}"

  tags = {
    "Name" = "${var.vpc_name}_env"
  }

}

########################################################
# Internet Gateway for your DC 
########################################################
resource "aws_internet_gateway" "dm_igw_res" {
  vpc_id = "${aws_vpc.dm_vpc_res.id}"


  tags = {
    Name = "${var.vpc_name}_env"
  }
}
