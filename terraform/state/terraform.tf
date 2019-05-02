terraform {
  backend "s3" {
    encrypt                = true
    bucket                 = "tf-webapp-state"
    region                 = "eu-west-1"
    skip_region_validation = "true"
    key                    = "global/s3/terraform.tfstate"
  }
}