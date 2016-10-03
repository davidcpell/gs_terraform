# need an IAM role for RDS

resource "aws_launch_configuration" "lc" {
  name_prefix = "test-config-"
  image_id = "${var.ami}"
  instance_type = "t2.micro"
  user_data = "${file("lib/user_data.sh")}"
  security_groups = ["${aws_security_group.sg-instance.id}"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg" {
  name = "test-asg"
  max_size = 2
  min_size = 1
  desired_capacity = 1
  health_check_grace_period = 90
  health_check_type = "ELB"
  load_balancers = ["${aws_elb.elb.id}"]
  launch_configuration = "${aws_launch_configuration.lc.name}"
  vpc_zone_identifier = ["${aws_subnet.priv1.id}", "${aws_subnet.priv2.id}"]

  tag {
    key = "Name"
    value = "test-asg"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "asp-up" {
  name = "test-asp-up"
  autoscaling_group_name = "${aws_autoscaling_group.asg.name}"
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  scaling_adjustment = 1
}

resource "aws_autoscaling_policy" "asp-down" {
  name = "test-asp-down"
  autoscaling_group_name = "${aws_autoscaling_group.asg.name}"
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  scaling_adjustment = -1
}

resource "aws_cloudwatch_metric_alarm" "alarm-inc" {
  alarm_name = "test-alarm-inc"
  alarm_description = "Trigger when CPU utilization is too high"
  alarm_actions = ["${aws_autoscaling_policy.asp-up.arn}"]
  namespace = "AWS/EC2"
  metric_name = "CPUUtilization"
  statistic = "Average"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold = "80"
  evaluation_periods = 2
  period = 60
  
  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.asg.name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "alarm-dec" {
  alarm_name = "test-alarm-dec"
  alarm_description = "Trigger when CPU utilization is back to normal"
  alarm_actions = ["${aws_autoscaling_policy.asp-down.arn}"]
  namespace = "AWS/EC2"
  metric_name = "CPUUtilization"
  statistic = "Average"
  comparison_operator = "LessThanOrEqualToThreshold"
  threshold = "20"
  evaluation_periods = 3
  period = 60
  
  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.asg.name}"
  }
}
