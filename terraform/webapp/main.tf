provider "aws" {
  region = "${var.region}"
}

module "networking" {
  source    = "modules/networking"
  vpc_cidr  = "${var.vpc_cidr}"
  elb_sg_id = "${module.security.elb_sg_id}"
}

module "instances" {
  source                  = "modules/instances"
  private_subnets_id      = "${module.networking.private_subnets_id}"
  webapp_elb_id           = "${module.networking.webapp_elb_id}"
  frontend_internal_sg_id = "${module.security.frontend_internal_sg_id}"
}

module "security" {
  source   = "modules/security"
  vpc_cidr = "${var.vpc_cidr}"
  vpc_id   = "${module.networking.vpc_id}"
}
