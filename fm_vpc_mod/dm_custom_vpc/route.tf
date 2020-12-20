#################################
# Route our traffic from subnets 
# - Route table 
# - Route 
# Route Association 
##################################

resource "aws_route_table" "dm_rt_tbl_public_res" {
  # count       = "${length(var.availability_zones)}"
  vpc_id = "${aws_vpc.dm_vpc_res.id}"

  tags = {
    "Name" = "DM PUBLIC ROUTE "
  }
}

resource "aws_route" "dm_rt_cidr_res" {
  route_table_id         = "${aws_route_table.dm_rt_tbl_public_res.id}"
  gateway_id             = "${aws_internet_gateway.dm_igw_res.id}"
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "dm_rt_assoc_public_res" {
  count          = "${length(var.availability_zones)}"
  subnet_id      = "${element(aws_subnet.dm_sn_pub_res.*.id, count.index)}"
  route_table_id = "${aws_route_table.dm_rt_tbl_public_res.id}"
}

### PRIVATE 
resource "aws_route_table" "dm_rt_tbl_private_res" {
  count  = "${length(var.availability_zones)}"
  vpc_id = "${aws_vpc.dm_vpc_res.id}"

  tags = {
    "Name" = "DM PRIVATE ROUTE - ${element(var.availability_zones, count.index)}"
  }
}

resource "aws_route" "dm_rt_ng_res" {
  count                  = "${length(var.availability_zones)}"
  route_table_id         = "${element(aws_route_table.dm_rt_tbl_private_res.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${element(aws_nat_gateway.dm_natg_res.*.id, count.index)}"
}

resource "aws_route_table_association" "dm_rt_assoc_private_res" {
  count          = "${length(var.availability_zones)}"
  subnet_id      = "${element(aws_subnet.dm_sn_priv_res.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.dm_rt_tbl_private_res.*.id, count.index)}"
}


