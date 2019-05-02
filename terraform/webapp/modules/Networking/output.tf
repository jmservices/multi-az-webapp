output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "private_subnets_id" {
  value = "${aws_subnet.private_subnets.*.id}"
}

output "public_subnets_id" {
  value = "${aws_subnet.public_subnets.*.id}"
}

output "webapp_elb_id" {
  value = "${aws_elb.webapp-elb.id}"
}

output "webapp_elb_dns_name" {
  value = "${aws_elb.webapp-elb.dns_name}"
}

output "webapp_nat_gateway_public_ip" {
  value = "${aws_nat_gateway.gw.public_ip}"
}
