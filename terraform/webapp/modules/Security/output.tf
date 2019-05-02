output "elb_sg_id" {
  value = "${aws_security_group.elb_sg.id}"
}

output "frontend_internal_sg_id" {
  value = "${aws_security_group.frontend_internal_sg.id}"
}
