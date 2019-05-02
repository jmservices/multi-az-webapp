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
