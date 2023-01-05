data "aws_iam_policy_document" "databrew_policy_document" {
  statement {
    sid = "allow"
    actions = [
      "glue:GetDatabases",
      "glue:GetPartitions",
      "glue:GetTable",
      "glue:GetTables",
      "glue:GetConnection",
      "glue:BatchGetCustomEntityTypes",
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
      "s3:ListBucket",
      "s3:DeleteObject",
      "s3:PutObjectAcl",
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
      "${aws_s3_bucket.scripts-bucket.arn}/*"
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
      "arn:aws:logs:*:*:log-group:/aws-glue-databrew/*",
    ]
  }
}


resource "aws_iam_policy" "databrew_policy" {
  name   = "DataBrewAccessPolicy"
  path   = "/"
  policy = data.aws_iam_policy_document.databrew_policy_document.json
}

#create a role and with sts:Assume role

resource "aws_iam_role" "databrew_access_role" {
  name               = "AWSDataBrewServiceRoleForDataBrewComponents"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["databrew.amazonaws.com"]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  tags = {
    tag-key = "AWSDataBrewServiceRoleForDataBrewComponents"
  }
}

#Attaching a policy to the role 

resource "aws_iam_role_policy_attachment" "databrew_policy_attachment" {
  role       = aws_iam_role.databrew_access_role.name
  policy_arn = aws_iam_policy.databrew_policy.arn
}
