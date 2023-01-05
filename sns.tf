// SNS topic for Glue Jobs and Glue Databrew Jobs

resource "aws_sns_topic" "glue_sns_topic" {
  name = "glue-sns-topic-${local.name_suffix}"
  display_name = "Job Failure Alert"
  tags = merge(
    { Name = "glue-sns-topic-${local.name_suffix}" },
    local.tags
  )
}

data "aws_iam_policy_document" "glue_sns_policy_document" {
  policy_id = "__default_policy_ID"

  statement {
    actions = [
        "SNS:Publish",
        "SNS:RemovePermission",
        "SNS:SetTopicAttributes",
        "SNS:DeleteTopic",
        "SNS:ListSubscriptionsByTopic",
        "SNS:GetTopicAttributes",
        "SNS:AddPermission",
        "SNS:Subscribe",
    ]
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"
      values = [
        var.account_number,
      ]
    }

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = [
      aws_sns_topic.glue_sns_topic.arn,
    ]

    sid = "__default_statement_ID"
  }
  statement {
    actions = [
        "SNS:Publish",
    ]
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [var.account_number]
    }

    resources = [
      aws_sns_topic.glue_sns_topic.arn,
    ]

    sid = "__console_pub_0"
  }
  statement {
    actions = [
        "SNS:Subscribe",
    ]
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = [
      aws_sns_topic.glue_sns_topic.arn,
    ]

    sid = "__console_sub_0"
  }
  statement {
    actions = [
        "SNS:Publish",
    ]
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    resources = [
      aws_sns_topic.glue_sns_topic.arn,
    ]

    sid = "event_publish"
  }
}

resource "aws_sns_topic_policy" "glue_topic_policy" {
  arn = aws_sns_topic.glue_sns_topic.arn
  policy = data.aws_iam_policy_document.glue_sns_policy_document.json
}

// SNS topic for S3 Failed objects


resource "aws_sns_topic" "s3_put_event_sns_topic" {
  name = "s3-put-event-sns-topic-${local.name_suffix}"
  display_name = "Data Quality Check Failure Alert"
  tags = merge(
    { Name = "s3-put-event-sns-topic-${local.name_suffix}" },
    local.tags
  )
}

data "aws_iam_policy_document" "s3_put_event_sns_policy_document" {
  policy_id = "__default_policy_ID"

  statement {
    actions = [
        "SNS:Publish",
    ]
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceAccount"
      values = [
        var.account_number,
      ]
    }
    condition{
        test      ="ArnLike"
        variable =  "AWS:SourceArn"
        values = [
            aws_s3_bucket.failed-staging-bucket.arn
        ]
    }

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    resources = [
      aws_sns_topic.s3_put_event_sns_topic.arn,
    ]

    sid = "__default_statement_ID"
  }
 
}

resource "aws_sns_topic_policy" "s3_put_event_topic_policy" {
  arn = aws_sns_topic.s3_put_event_sns_topic.arn
  policy = data.aws_iam_policy_document.s3_put_event_sns_policy_document.json
}
