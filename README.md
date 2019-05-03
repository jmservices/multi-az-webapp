# Infrastructure for Multi-AZ web application



## Tools used:

Docker - webapp application
Packer - create AMI
AWS CLI - AWS command line interface
Terraform - deploy IaaC

## Setup steps

### 1. Clone this repository to your local environment.

### 2. AWS CLI setup:
    1. Install AWS CLI. 
        1. Command: bash brew install aws cli 
    2. Configure AWS CLI
        1. Command: aws configure 
        2. Insert your IAM user AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, region “eu-west-1” and output type.

### 3. Packer setup:
    1. Install Packer
        1. Command: brew install packer
    2. Configure Packer to build AMI. It is required to have AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY and IAM user with appropriate permissions.
        1. Command: export AWS_ACCESS_KEY_ID={your AWS_ACCESS_KEY_ID}
        2. Command: export AWS_SECRET_ACCESS_KEY={your AWS_SECRET_ACCESS_KEY}
    3. Subscribe for CentOS AMI if require : https://aws.amazon.com/marketplace/pp?sku=aw0evgkw8e5c1q413zgy5pjce
    4. Validate and build web app AMI.
        1. Command: packer validate webapp.js
        2. Command: packer build webapp.js

### 4. Provision AWS infrastructure using Terraform:
    1. Deploy S3 bucket to store Terraform states.
        1. Switch to terraform/state/ directory.
        2. Change “s3_name“ variable value in variables.tf to something unique. That will be re-used in further steps.
        3. Change value of attribute “bucket” in terraform.tf to the same what was used in 4.1.2. for “s3_name”.
        4. Create S3 bucket:
            1. Command: terraform init
            2. Command: terraform apply
        5. Remove “_postinit” from terraform.tf_postinit file.
        6. Move terraform states from local to s3
            1. Command: terraform init
    2. Deploy multi-az infrastructure
        1. Switch to terraform/webapp directory.
        2. Change value of attribute “bucket” in terraform.tf to the same what was used in 4.1.2 for “s3_name”.
        3. Initialize Terraform project.
            1. Command: terraform init
        4. Create “terraform-key-webapp” Key Pair via AWS Console in Ireland region.
        5. Conduct a dry run to validate terraform code
            1. Command: terraform plan
        6. Provision AWS resources via terraform:
            1. Command: terraform apply
            2. Wait for AWS resources creation.
        7. Wait for a couple of minutes for EC2 instances initialization and later copy “webapp_elb_dns_name” value to your browser to check if web app is available.
