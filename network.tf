resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"

  tags {
    Name = "test-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "10.0.1.0/24"
  availability_zone = "${var.pub_subnet_az}"

  tags {
    Name = "test-subnet-public"
  }
}

resource "aws_subnet" "priv1" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "10.0.2.0/24"
  availability_zone = "${element(split(",", var.priv_subnet_azs), 0)}"
}

resource "aws_subnet" "priv2" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "10.0.3.0/24"
  availability_zone = "${element(split(",", var.priv_subnet_azs), 1)}"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"
}

resource "aws_route_table" "pub-rt" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }
}

resource "aws_route_table_association" "igw" {
  subnet_id = "${aws_subnet.public.id}"
  route_table_id = "${aws_route_table.pub-rt.id}"
}
