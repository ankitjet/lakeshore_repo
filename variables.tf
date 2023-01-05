variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "availabilityZone" {
  default = "us-west-2a"
}

variable "resource_tags" {
  description = "Tags to set for all resources"
  type        = map(string)
  default     = {}
}

variable "project_name" {
  description = "Name of the project."
  type        = string
  default     = ""
}

variable "environment" {
  description = "Name of the environment."
  type        = string
  default     = ""
}

variable "business" {
  description = "Name of the business"
  type        = string
  default     = ""
}

variable "department" {
  description = "Name of the department."
  type        = string
  default     = ""
}

variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "enable_vpn_gateway" {
  description = "Enable a VPN gateway in your VPC."
  type        = bool
  default     = false
}

variable "public_subnet_count" {
  description = "Number of public subnets."
  type        = number
  default     = 2
}

variable "private_subnet_count" {
  description = "Number of private subnets."
  type        = number
  default     = 2
}

# VPC variables

variable "vpcCIDRblock" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.160.8.0/21"
}

variable "instanceTenancy" {
  description = "Tenancy for VPC"
  type        = string
  default     = "default"
}

variable "dnsSupport" {
  default = true
}
variable "dnsHostNames" {
  default = false
}
variable "subnetCIDRblock" {
  default = "10.160.8.0/21"
}

variable "mapPublicIP" {
  default = false
}

variable "securityGroupName" {
  default = "Datalake-test Security Group"
}

variable "securityGroupDescription" {
  default = "Datalake-test Security Group"
}

variable "ingressCIDRblock" {
  type    = list(any)
  default = ["10.1.101.135/32", "10.1.101.209/32"]
}

variable "securityGroupIngressDescription" {
  default = "Rule for port 22"
}

variable "region_suffix" {
  description = "Short version of region to use in naming of resources"
  type        = string
  default     = "usw2"
}

# Redshift Variables

variable "node_count" {
  type        = number
  description = "Number of nodes for multi-node"
  default     = 8
}

variable "node_type" {
  type        = string
  description = "Node type for RedShift cluster"
  default     = "dc2.large"

}

variable "redshift_username" {
  type        = string
  description = "Username for the Master DB User"
  default     = "admin"
}

variable "redshift_password" {
  type        = string
  description = "Password for the Master DB User"
}

variable "cluster_identifier" {
  type        = string
  description = "Identifier for the cluster"
}

variable "database_name" {
  type        = string
  description = "Name of the database"
}

variable "redshift_kms_key_id" {
  type        = string
  description = "KMS key arn to use for RedShift instance"
}


variable "redshift_logging_prefix" {
  type        = string
  description = "S3 key prefix to use for RedShift logs"
}

#GlueJobs

variable "script_path1" {
  type        = string
  description = "Location of the glue job script"
}

variable "working_directory1" {
  type        = string
  description = "Path of the Working Directory"
}

# Glue Crawler variables

variable "crawler_s3_path" {
  type        = string
  description = "S3 Path for Crawler"
}

#Event variable and SNS Topics

variable "account_number" {
  type        = number
  description = "AWS Account Number"
}

variable "step_function_name" {
  type        = string
  description = "name of the Step Function for the Event Target"
}
