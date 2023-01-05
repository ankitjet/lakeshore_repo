# Terraform configuration

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.34.0"
    }
  }

  backend "s3" {
    # Replace these details according to environment
    bucket         = "datalake-dev-tfstate-bucket"
    key            = "lakeshore/datalake-dev/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "datalake-dev-tfstate-lock-table"
    encrypt        = true
    #profile = "dev-datalake"
  }

}