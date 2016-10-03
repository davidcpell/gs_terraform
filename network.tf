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

  tags {
    Name = "test-subnet-priv1"
  }
}

resource "aws_subnet" "priv2" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "10.0.3.0/24"
  availability_zone = "${element(split(",", var.priv_subnet_azs), 1)}"

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
  subnet_id = "${aws_subnet.public.id}"
}

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

resource "aws_security_group" "sg-elb" {
  name = "test-sg-elb"
  description = "allow HTTP from anywhere"
  vpc_id = "${aws_vpc.vpc.id}"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "test-sg-elb"
  }
}

resource "aws_security_group" "sg-instance" {
  name = "test-sg-instance"
  description = "allow HTTP from sg-elb"
  vpc_id = "${aws_vpc.vpc.id}"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = ["${aws_security_group.sg-elb.id}"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "test-sg-instance"
  }
}
