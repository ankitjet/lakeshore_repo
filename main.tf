provider "aws" {
  region = var.aws_region
  #profile = "test-datalake"
}

locals {
  required_tags = {
    project     = var.project_name,
    environment = var.environment,
    department  = var.department,
    business    = var.business

  }

  tags = merge(var.resource_tags, local.required_tags)

  name_suffix = "${var.region_suffix}-${var.project_name}-${var.environment}"
}

data "aws_availability_zone" "az1" {
  name = "${var.aws_region}a"
}

data "aws_availability_zone" "az2" {
  name = "${var.aws_region}b"
}

data "aws_ec2_transit_gateway" "tgw" {
  filter {
    name   = "options.amazon-side-asn"
    values = [65160]
  }
}

module "network" {
  source = "./modules/terraform-aws-network"
}

module "security" {
  source = "./modules/terraform-aws-security"
}

module "app" {
  source = "./modules/terraform-aws-app"
}


