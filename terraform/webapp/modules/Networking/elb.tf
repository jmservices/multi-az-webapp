resource "aws_elb" "webapp-elb" {
  name            = "Webapp-ELB"
  subnets         = ["${aws_subnet.public_subnets.*.id}"]
  security_groups = ["${var.elb_sg_id}"]

  internal = false

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  instances                   = []
  cross_zone_load_balancing   = true
  idle_timeout                = 40
  connection_draining         = true
  connection_draining_timeout = 40

  tags = {
    Name = "Webapp-ELB"
  }
}
