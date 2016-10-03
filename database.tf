resource "aws_db_subnet_group" "db-subnet-group" {
  name       = "db-subnet-group"
  subnet_ids = ["${aws_subnet.priv1.id}", "${aws_subnet.priv2.id}"]

  tags {
    Name = "game-service-db-subnet-group"
  }
}

resource "aws_db_instance" "db" {
  allocated_storage = 20
  engine            = "postgres"
  instance_class    = "db.t2.micro"
  identifier        = "game-service-db"
  name              = "game_service_db"
  username          = "david"
  password          = "password"
  availability_zone = "${aws_subnet.priv1.availability_zone}"
  vpc_security_group_ids = ["${aws_security_group.sg-db.id}"]
  db_subnet_group_name = "${aws_db_subnet_group.db-subnet-group.name}"
}

resource "aws_route53_record" "db" {
  zone_id = "${var.route53_zone_id}"
  name    = "db.gameservice.davidpell.net"
  type    = "CNAME"
  records = ["${aws_db_instance.db.address}"]
  ttl     = 60
}
