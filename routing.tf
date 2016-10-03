resource "aws_route_table" "pub-rt" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags {
    Name = "test-rt-igw"
  }
}

resource "aws_route_table" "nat-rt" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.nat.id}"
  }

  tags {
    Name = "test-rt-nat"
  }
}

resource "aws_route_table_association" "rta-igw" {
  subnet_id = "${aws_subnet.public.id}"
  route_table_id = "${aws_route_table.pub-rt.id}"
}

resource "aws_route_table_association" "rta-nat1" {
  subnet_id = "${aws_subnet.priv1.id}"
  route_table_id = "${aws_route_table.nat-rt.id}"
}

resource "aws_route_table_association" "rta-nat2" {
  subnet_id = "${aws_subnet.priv2.id}"
  route_table_id = "${aws_route_table.nat-rt.id}"
}
