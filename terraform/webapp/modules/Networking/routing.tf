resource "aws_route_table" "public_route" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.ig.id}"
  }

  tags {
    Name = "Public route table"
  }

  depends_on = ["aws_vpc.vpc"]
}

resource "aws_route_table" "nat_route" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.ig.id}"
  }

  tags {
    Name = "NAT route table"
  }

  depends_on = ["aws_vpc.vpc"]
}

resource "aws_route_table" "private_route" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.gw.id}"
  }

  tags {
    Name = "NAT route table"
  }

  depends_on = ["aws_vpc.vpc"]
}

resource "aws_route_table_association" "nat_assocs" {
  subnet_id      = "${aws_subnet.nat_subnet.id}"
  route_table_id = "${aws_route_table.nat_route.id}"
}

resource "aws_route_table_association" "public_assocs" {
  count          = "${length(data.aws_availability_zones.available.names)}"
  subnet_id      = "${element(aws_subnet.public_subnets.*.id, count.index)}"
  route_table_id = "${aws_route_table.public_route.id}"
}

resource "aws_route_table_association" "private_assocs" {
  count          = "${length(data.aws_availability_zones.available.names)}"
  subnet_id      = "${element(aws_subnet.private_subnets.*.id, count.index)}"
  route_table_id = "${aws_route_table.private_route.id}"
}
