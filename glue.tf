data "aws_iam_policy_document" "glue_policy_document" {
  statement {
    sid = "allow"
    actions = [
      "glue:*",
      "s3:GetBucketLocation",
      "s3:ListBucket",
      "s3:ListAllMyBuckets",
      "s3:GetBucketAcl",
      "iam:ListRolePolicies",
      "iam:GetRole",
      "iam:GetRolePolicy",
      "cloudwatch:PutMetricData",
    ]
    resources = [
      "*"
    ]
  }
  statement {
    sid = "allowS3"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
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
  statement {
    sid = "allowlogs"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = [
      "arn:aws:logs:*:*:/aws-glue/*",
    ]
  }
  statement {
    sid = "passroleforglue"
    actions = [
      "iam:PassRole",
    ]
    resources = [
      "arn:aws:iam::*:role/AWSGlueServiceRole*",
    ]
    condition{
      test     = "ForAnyValue:StringEquals"
      variable = "iam:PassedToService"
      values   = ["glue.amazonaws.com"]
    }
  }

  statement {
    sid = "passroleforec2"
    actions = [
      "iam:PassRole",
    ]
    resources = [
      "arn:aws:iam::*:role/AWSGlueServiceNotebookRole*",
    ]
    condition{
      test     = "ForAnyValue:StringEquals"
      variable = "iam:PassedToService"
      values   = ["ec2.amazonaws.com"]
    }
  }
}


resource "aws_iam_policy" "glue_policy" {
  name   = "GlueAccessPolicy"
  path   = "/"
  policy = data.aws_iam_policy_document.glue_policy_document.json
}
// create a role and with sts:Assume role

resource "aws_iam_role" "glue_access_role" {
  name               = "AWSGlueServiceRoleForGlueComponents"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["glue.amazonaws.com"]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  tags = {
    tag-key = "glue-access-role"
  }
}

//attaching a policy to the role 

resource "aws_iam_role_policy_attachment" "glue_policy_attachment" {
  role       = aws_iam_role.glue_access_role.name
  policy_arn = aws_iam_policy.glue_policy.arn
}


resource "aws_glue_catalog_database" "sample_database" {
  name = "sample-database-${local.name_suffix}"
  description = "Database for Lakeshore Learning" 
}

module "glue-job1"{
    source = "./modules/gluejobs"
    job_cloudwatch_log_group = "sample-job1-cloudwatch-log-group-${local.name_suffix}"
    glue_job_name = "sample-job1-${local.name_suffix}"
    glue_role = aws_iam_role.glue_access_role.arn
    maximum_retries = 0
    workers = 2
    type_of_worker = "G.1X"
    time = 15
    script_loc = var.script_path1
    temporary_directory = var.working_directory1
    env = var.environment
}
  
resource "aws_glue_crawler" "glue_crawler" {
  database_name = aws_glue_catalog_database.sample_database.name
  name          = "glue-crawler-${local.name_suffix}"
  role          = aws_iam_role.glue_access_role.arn

  s3_target {
    path = var.crawler_s3_path
  }
  
  tags = merge(
    { Name = "glue-crawler-${local.name_suffix}" },
    local.tags
  )
}
