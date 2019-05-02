resource "aws_subnet" "private_subnets" {
  count                   = "${length(data.aws_availability_zones.available.names)}"
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index + 1)}"
  map_public_ip_on_launch = false
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"

  lifecycle {
    create_before_destroy = true
  }

  tags {
    Name   = "Private Subnet ${data.aws_availability_zones.available.names[count.index]}"
    public = true
  }

  depends_on = ["aws_vpc.vpc"]
}

resource "aws_subnet" "nat_subnet" {
  vpc_id = "${aws_vpc.vpc.id}"

  cidr_block              = "${cidrsubnet(aws_vpc.vpc.cidr_block, 8, 4)}"
  map_public_ip_on_launch = true
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name   = "Public subnet"
    public = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_subnet" "public_subnets" {
  count                   = "${length(data.aws_availability_zones.available.names)}"
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index + 5)}"
  map_public_ip_on_launch = false
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"

  lifecycle {
    create_before_destroy = true
  }

  tags {
    Name   = "Pubic Subnet ${data.aws_availability_zones.available.names[count.index]}"
    public = true
  }

  depends_on = ["aws_vpc.vpc"]
}
