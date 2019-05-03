resource "aws_launch_configuration" "webapp-lc" {
  name          = "webapp-config"
  image_id      = "${data.aws_ami.ami.id}"
  instance_type = "t2.micro"

  key_name = "terraform-key-webapp"

  associate_public_ip_address = false

  security_groups = ["${var.frontend_internal_sg_id}"]

  root_block_device = [
    {
      volume_size           = "8"
      volume_type           = "gp2"
      delete_on_termination = true
    },
  ]
}

resource "aws_autoscaling_group" "webapp-asg" {
  name                 = "terraform-asg-webapp"
  launch_configuration = "${aws_launch_configuration.webapp-lc.name}"
  min_size             = 3
  max_size             = 6

  vpc_zone_identifier = ["${var.private_subnets_id}"]
  force_delete        = true

  default_cooldown          = 10
  health_check_grace_period = 10

  tag {
    key                 = "Name"
    value               = "WebApp instance"
    propagate_at_launch = "true"
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = ["desired_capacity"]
  }
}

resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = "${aws_autoscaling_group.webapp-asg.id}"
  elb                    = "${var.webapp_elb_id}"
}

resource "aws_autoscaling_schedule" "webapp_peak_scale_out" {
  scheduled_action_name  = "Peak time"
  min_size               = 6
  max_size               = 9
  desired_capacity       = 6
  recurrence             = "0 12 * * *"
  autoscaling_group_name = "${aws_autoscaling_group.webapp-asg.name}"
}

resource "aws_autoscaling_schedule" "webapp_peak_scale_in" {
  scheduled_action_name  = "Off peak"
  min_size               = 3
  max_size               = 6
  desired_capacity       = 3
  recurrence             = "0 20 * * *"
  autoscaling_group_name = "${aws_autoscaling_group.webapp-asg.name}"
}

resource "aws_autoscaling_schedule" "webapp_night_scale_in" {
  scheduled_action_name  = "Night"
  min_size               = 1
  max_size               = 6
  desired_capacity       = 1
  recurrence             = "0 0 * * *"
  autoscaling_group_name = "${aws_autoscaling_group.webapp-asg.name}"
}

resource "aws_autoscaling_schedule" "webapp_day_scale_out" {
  scheduled_action_name  = "Morning"
  min_size               = 3
  max_size               = 6
  desired_capacity       = 3
  recurrence             = "0 6 * * *"
  autoscaling_group_name = "${aws_autoscaling_group.webapp-asg.name}"
}

resource "aws_cloudwatch_metric_alarm" "webapp_hight_cpu_alert" {
  alarm_name          = "WebApp HIGH CPU utilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "40"

  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.webapp-asg.name}"
  }

  alarm_description = "WebApp >40% CPU utilization"
  alarm_actions     = ["${aws_autoscaling_policy.webapp_cpu_scale_out.arn}"]
}

resource "aws_autoscaling_policy" "webapp_cpu_scale_out" {
  name                   = "WebApp CPU Scale out"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 30
  autoscaling_group_name = "${aws_autoscaling_group.webapp-asg.name}"
}

resource "aws_cloudwatch_metric_alarm" "webapp_low_cpu_alert" {
  alarm_name          = "WebApp LOW CPU utilization"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "10"

  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.webapp-asg.name}"
  }

  alarm_description = "WebApp <10% CPU utilization"
  alarm_actions     = ["${aws_autoscaling_policy.webapp_cpu_scale_out.arn}"]
}

resource "aws_autoscaling_policy" "webapp_cpu_scale_in" {
  name                   = "WebApp CPU Scale in"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 30
  autoscaling_group_name = "${aws_autoscaling_group.webapp-asg.name}"
}