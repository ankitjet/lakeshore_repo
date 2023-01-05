#Create security group for Redshift 

resource "aws_security_group" "redshift_sg" {
  name        = "redshift-sg-${local.name_suffix}"
  description = "Security Group for Redshift Cluster. Managed by Terraform."
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 5439
    to_port     = 5439
    protocol    = "tcp"
    cidr_blocks = ["10.90.160.0/23"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    { Name = "redshift-sg-${local.name_suffix}" },
    local.tags
  )
}

resource "aws_security_group_rule" "rule2" {
  type              = "ingress"
  from_port         = -1
  to_port           = -1
  protocol          = "-1"
  self              = true
  security_group_id = aws_security_group.redshift_sg.id
}


//define subnet group for our cluster

resource "aws_redshift_subnet_group" "redshift_subnet_group" {
  name       = "redshift-subnet-group"
  subnet_ids = [aws_subnet.private1.id, aws_subnet.private2.id]
  tags = {
    Name = "redshift-subnet-group"
  }
}

// creating a policy to attach to the role for allowing the cluster to read and write data to S3 buckets

data "aws_iam_policy_document" "redshift_policy_document" {
  statement {
    sid = "allowS3"
    actions = [
      "s3:GetObject",
      "s3:GetBucketAcl",
      "s3:PutObjectAcl",
      "s3:GetObjectAcl",
      "s3:GetBucketCors",
      "s3:GetEncryptionConfiguration",
      "s3:GetBucketLocation",
      "s3:ListBucket",
      "s3:ListAllMyBuckets",
      "s3:ListMultipartUploadParts",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject",
      "s3:PutBucketAcl",
      "s3:PutBucketCors",
      "s3:DeleteObject",
      "s3:AbortMultipartUpload",
    ]
    resources = [
      aws_s3_bucket.logging-bucket.arn,
      "${aws_s3_bucket.logging-bucket.arn}/*",
      aws_s3_bucket.cleansed-staging-bucket.arn,
      "${aws_s3_bucket.cleansed-staging-bucket.arn}/*",
      aws_s3_bucket.msk-source-landing-bucket.arn,
      "${aws_s3_bucket.msk-source-landing-bucket.arn}/*",
      aws_s3_bucket.historical-source-landing-bucket.arn,
      "${aws_s3_bucket.historical-source-landing-bucket.arn}/*",
      aws_s3_bucket.unclean-staging-bucket.arn,
      "${aws_s3_bucket.unclean-staging-bucket.arn}/*",
      aws_s3_bucket.flagged-staging-bucket.arn,
      "${aws_s3_bucket.flagged-staging-bucket.arn}/*",
      aws_s3_bucket.adhoc-staging-bucket.arn,
      "${aws_s3_bucket.adhoc-staging-bucket.arn}/*",
      aws_s3_bucket.failed-staging-bucket.arn,
      "${aws_s3_bucket.failed-staging-bucket.arn}/*",
      aws_s3_bucket.scripts-bucket.arn,
      "${aws_s3_bucket.scripts-bucket.arn}/*",
      aws_s3_bucket.modeled-staging-bucket.arn,
      "${aws_s3_bucket.modeled-staging-bucket.arn}/*"
    ]
  }
}

resource "aws_iam_policy" "s3_policy" {
  name   = "RedshiftS3Policy"
  path   = "/"
  policy = data.aws_iam_policy_document.redshift_policy_document.json
}

// create a role and with sts:Assume role

resource "aws_iam_role" "redshift_role" {
  name               = "redshift_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "redshift.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  tags = {
    tag-key = "redshift-role"
  }
}

//attaching a policy to the role 

resource "aws_iam_role_policy_attachment" "redshift_S3_policy_attachment" {
  role       = aws_iam_role.redshift_role.name
  policy_arn = aws_iam_policy.s3_policy.arn
}
// to create redshift cluster

resource "aws_redshift_cluster" "llm-dev-cluster" {
  cluster_identifier = var.cluster_identifier
  database_name      = var.database_name

  node_type       = var.node_type
  number_of_nodes = var.node_count
  cluster_type    = "multi-node"

  publicly_accessible  = false //Depends on the requirement
  enhanced_vpc_routing = false

  master_username = var.redshift_username
  master_password = var.redshift_password

  encrypted                           = true
  kms_key_id                          = var.redshift_kms_key_id
  iam_roles                           = [aws_iam_role.redshift_role.arn]
  skip_final_snapshot                 = true
  apply_immediately                   = true
  preferred_maintenance_window        = "sat:23:00-sat:23:30"
  automated_snapshot_retention_period = 7
  #final_snapshot_identifier           = "rds-cluster-backup"
  cluster_subnet_group_name           = aws_redshift_subnet_group.redshift_subnet_group.name
  cluster_parameter_group_name        = aws_redshift_parameter_group.main.name
  vpc_security_group_ids              = [aws_security_group.redshift_sg.id]

  logging {
    enable        = true
    bucket_name   = aws_s3_bucket.logging-bucket.id
    s3_key_prefix = var.redshift_logging_prefix
  }

  tags = merge(
    { Name = "redshift-${local.name_suffix}" },
    local.tags
  )
}

//declaring parameter --this may change based on the requirement from the user

resource "aws_redshift_parameter_group" "main" {
  name   = "parameter-group-test-terraform"
  family = "redshift-1.0"

  parameter {
    name  = "require_ssl"
    value = "true"
  }

  parameter {
    name  = "query_group"
    value = "default"
  }

  parameter {
    name  = "enable_user_activity_logging"
    value = "true"
  }

  parameter {
    name  = "enable_case_sensitive_identifier"
    value = "false"
  }

  parameter {
    name  = "auto_analyze"
    value = "true"
  }

  parameter {
    name  = "datestyle"
    value = "ISO,MDY"
  }

  parameter {
    name  = "extra_float_digits"
    value = 0
  }

  parameter {
    name  = "search_path"
    value = "$user,public"
  }

  parameter {
    name  = "statement_timeout"
    value = 0
  }

  parameter {
    name  = "use_fips_ssl"
    value = "false"
  }
  parameter {
    name  = "auto_mv"
    value = "false"
  }

  parameter {
    name = "wlm_json_configuration"
    value = jsonencode(
      [
        {
          "name" : "DE",
          "priority" : "high",
          "query_group" : [],
          "queue_type" : "auto",
          "user_group" : ["DE"]
        },
        {
          "name" : "default queue",
          "query_group" : [],
          "queue_type" : "auto",
          "user_group" : []
        },
        {
          "short_query_queue" : true,
          "auto_wlm" : true,
        "concurrency_scaling" : "off" }
      ]
    )
  }
}
