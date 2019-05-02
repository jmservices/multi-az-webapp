resource "aws_security_group" "elb_sg" {
  name        = "Frontend_ELB_sg"
  description = "Used for public access to front end apps."
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "frontend_internal_sg" {
  name        = "Frontend_internal_sg"
  description = "Used for ELB internal access to frontend apps."
  vpc_id      = "${var.vpc_id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = ["aws_security_group.elb_sg"]
}

resource "aws_security_group_rule" "frontend_internal_sg_rule" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  security_group_id        = "${aws_security_group.frontend_internal_sg.id}"
  source_security_group_id = "${aws_security_group.elb_sg.id}"

  depends_on = ["aws_security_group.frontend_internal_sg"]
}
