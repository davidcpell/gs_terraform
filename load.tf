resource "aws_elb" "elb" {
  name = "test-elb"
  subnets = ["${aws_subnet.public1.id}", "${aws_subnet.public2.id}"]
  cross_zone_load_balancing = true
  security_groups = ["${aws_security_group.sg-elb.id}"]

  listener {
    instance_port = 80
    instance_protocol = "HTTP"
    lb_port = 80
    lb_protocol = "HTTP"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    target = "TCP:80"
    interval = 10
    timeout = 5
  }
}
