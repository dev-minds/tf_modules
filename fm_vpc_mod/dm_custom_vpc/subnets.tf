########################################
# Subents defined for public and private
# - Public 
# - Private
# - NAT G 
# - EiP 
# https://www.tecmint.com/calculate-ip-subnet-address-with-ipcalc-tool/
# https://www.terraform.io/docs/configuration/functions/cidrsubnet.html
# http://blog.itsjustcode.net/blog/2017/11/18/terraform-cidrsubnet-deconstructed/
########################################

### PUBLIC 
resource "aws_subnet" "dm_sn_pub_res" {
  count  = "${length(var.availability_zones)}"
  vpc_id = "${aws_vpc.dm_vpc_res.id}"

  cidr_block              = "${cidrsubnet(var.cidr_block, 8, count.index)}"
  availability_zone       = "${element(var.availability_zones, count.index)}"
  map_public_ip_on_launch = "true"

  tags = {
    "Name" = "${var.name_tag}-public-subnet-${element(var.availability_zones, count.index)}"
  }
}

### PRIVATE
resource "aws_subnet" "dm_sn_priv_res" {
  count                   = "${length(var.availability_zones)}"
  vpc_id                  = "${aws_vpc.dm_vpc_res.id}"
  cidr_block              = "${cidrsubnet(var.cidr_block, 8, count.index + length(var.availability_zones))}"
  availability_zone       = "${element(var.availability_zones, count.index)}"
  map_public_ip_on_launch = "false"

  tags = {
    "Name" = "${var.name_tag}-private-subnet-${element(var.availability_zones, count.index)}"
  }
}

# EIP 
resource "aws_eip" "dm_eip_res" {
  count = "${length(var.availability_zones)}"
  vpc   = true

  tags = {
    "Name" = "${var.name_tag}-eip-${element(var.availability_zones, count.index)}"
  }
}

# NAT G 
resource "aws_nat_gateway" "dm_natg_res" {
  count         = "${length(var.availability_zones)}"
  subnet_id     = "${element(aws_subnet.dm_sn_pub_res.*.id, count.index)}"
  allocation_id = "${element(aws_eip.dm_eip_res.*.id, count.index)}"

  tags = {
    "Name" = "${var.name_tag}-nat-gtw-${element(var.availability_zones, count.index)}"
  }
}
