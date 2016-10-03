resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"

  tags {
    Name = "test-vpc"
  }
}

resource "aws_subnet" "public1" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "10.0.1.0/24"
  availability_zone = "${element(split(",", var.azs), 0)}"

  tags {
    Name = "test-subnet-public1"
  }
}

resource "aws_subnet" "public2" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "10.0.2.0/24"
  availability_zone = "${element(split(",", var.azs), 1)}"

  tags {
    Name = "test-subnet-public2"
  }
}

resource "aws_subnet" "priv1" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "10.0.3.0/24"
  availability_zone = "${element(split(",", var.azs), 0)}"

  tags {
    Name = "test-subnet-priv1"
  }
}

resource "aws_subnet" "priv2" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "10.0.4.0/24"
  availability_zone = "${element(split(",", var.azs), 1)}"

  tags {
    Name = "test-subnet-priv2"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"
}

resource "aws_eip" "eip" {
  vpc = true
}

resource "aws_nat_gateway" "nat" {
  allocation_id = "${aws_eip.eip.id}"
  subnet_id = "${aws_subnet.public1.id}"
}
