#Event for Glue Jobs

resource "aws_cloudwatch_event_rule" "Job_Failure_Event_Rule" {
  name        = "job-failure-event-rule-${local.name_suffix}"
  description = "Trigger for failed , stopped and error events"

  event_pattern = <<EOF
{
  "detail-type": ["Glue Job State Change"],
  "source": ["aws.glue"],
  "detail": {
    "state": ["STOPPED", "FAILED", "ERROR", "TIMEOUT"]
  }
}
EOF

  tags = merge(
    { Name = "job-failure-event-rule-${local.name_suffix}" },
      local.tags
    )
}

resource "aws_cloudwatch_event_target" "Job_Failure_Event_Rule_Target" {
  rule      = aws_cloudwatch_event_rule.Job_Failure_Event_Rule.name
  target_id = "SendToSNS"
  arn       = aws_sns_topic.glue_sns_topic.arn
}



#Event for DataBrew Job 

resource "aws_cloudwatch_event_rule" "DataBrew_Job_Failure_Event_Rule" {
  name        = "databrew-job-failure-event-rule-${local.name_suffix}"
  description = "trigger for failed , stopped and error events"

  event_pattern = <<EOF
{
  "source": ["aws.databrew"],
  "detail-type": ["DataBrew Job State Change"],
  "detail": {
    "state": ["STOPPED", "FAILED", "ERROR", "TIMEOUT"]
  }
}
EOF
  tags = merge(
    { Name = "databrew-job-failure-event-rule-${local.name_suffix}" },
      local.tags
    )
}

resource "aws_cloudwatch_event_target" "DataBrew_Job_Failure_Event_Rule_Target" {
  rule      = aws_cloudwatch_event_rule.DataBrew_Job_Failure_Event_Rule.name
  target_id = "SendToSNS"
  arn       = aws_sns_topic.glue_sns_topic.arn
}

# Event for Step function

resource "aws_cloudwatch_event_rule" "trigger_step_function" {
  name                = "trigger-step-function-rule-${local.name_suffix}"
  description         = "scheduling job to trigger step function"
  schedule_expression = "cron(0 0/1 * * ? *)"
  tags = merge(
    { Name = "trigger-step-function-rule-${local.name_suffix}" },
      local.tags
    )
}

data "aws_iam_policy_document" "trigger_step_function_policy_document" {
  statement {
    sid = "allow"
    actions = [
      "states:StartExecution",
    ]
    resources = [
      "arn:aws:states:us-west-2:${var.account_number}:stateMachine:*"
    ]
  }
}

resource "aws_iam_policy" "trigger_step_function_policy" {
  name   = "trigger-step-function-policy"
  policy = data.aws_iam_policy_document.trigger_step_function_policy_document.json
}

resource "aws_iam_role" "trigger_step_function_role" {
  name               = "trigger-step-function-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
            "Effect": "Allow",
            "Principal": {
                "Service": "events.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
      }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "step_function_attachment" {
  role       = aws_iam_role.trigger_step_function_role.name
  policy_arn = aws_iam_policy.trigger_step_function_policy.arn
}

resource "aws_cloudwatch_event_target" "step_function_target" {
  target_id = "SendtoStepFunction"
  arn       = var.step_function_name
  rule      = aws_cloudwatch_event_rule.trigger_step_function.name
  role_arn  = aws_iam_role.trigger_step_function_role.arn
}
