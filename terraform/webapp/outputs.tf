output "vpc_id" {
  value       = "${module.networking.vpc_id}"
  description = "VPC ID"
}

output "private_subnets_id" {
  value       = "${module.networking.private_subnets_id}"
  description = "List of private subnets"
}

output "public_subnets_id" {
  value       = "${module.networking.public_subnets_id}"
  description = "List of public subnets"
}

output "webapp_elb_dns_name" {
  value       = "${module.networking.webapp_elb_dns_name}"
  description = "Elastic Load Balancer Public DNS"
}

output "webapp_nat_gateway_public_ip" {
  value       = "${module.networking.webapp_nat_gateway_public_ip}"
  description = "NAT Public IP"
}
