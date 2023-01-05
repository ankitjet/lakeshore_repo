project_name  = "datalake"
environment   = "dev"
department    = "data engineering"
business      = "technology"
region_suffix = "usw2"

aws_region = "us-west-2"

vpc_cidr_block          = "10.160.24.0/21"

#redshift cluster
node_count              = 2
cluster_identifier      = "edlh-usw2-datalake-dev"
database_name           = "edlh_usw2_datalake_dev"
redshift_kms_key_id     = "arn:aws:kms:us-west-2:716039874842:key/04d98bdd-ff66-41a7-9c5b-4b3d539673c0"
redshift_logging_prefix = "redshift-logs"
redshift_username       = "admin"
#Glue Jobs
script_path1            = "s3://adhoc-staging-bucket-usw2-datalake-dev/GlueJobsScripts/sample.py"
working_directory1      = "s3://adhoc-staging-bucket-usw2-datalake-dev/GlueTemporaryWorkingDirectory/"
#SNS Topic
account_number          = 716039874842
#Glue Crawler
crawler_s3_path         = "s3://msk-source-landing-bucket-usw2-datalake-dev/poc-sample"
#Event Target
step_function_name      = "arn:aws:states:us-west-2:716039874842:stateMachine:test"
