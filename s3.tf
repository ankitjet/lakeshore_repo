resource "aws_s3_bucket" "logging-bucket" {
  bucket        = "logging-bucket-${local.name_suffix}"
  force_destroy = true
  lifecycle {
    ignore_changes = [server_side_encryption_configuration, lifecycle_rule]
  }
  tags = merge(
    { Name = "logging-bucket-${local.name_suffix}" },
    local.tags
  )
}

resource "aws_s3_bucket_acl" "logging-bucket_acl" {
  bucket = aws_s3_bucket.logging-bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "logging-bucket_sse" {
  bucket = aws_s3_bucket.logging-bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "logging-bucket_versioning" {
  bucket = aws_s3_bucket.logging-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "logging-bucket_pab" {
  bucket                  = aws_s3_bucket.logging-bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

}


resource "aws_s3_bucket_policy" "logging-bucket-policy-attach" {
  bucket = aws_s3_bucket.logging-bucket.id
  policy = data.aws_iam_policy_document.logging-bucket-policy.json
}

data "aws_iam_policy_document" "logging-bucket-policy" {
  statement {
    sid = "ssl-required"
    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:*"
    ]

    resources = [
      aws_s3_bucket.logging-bucket.arn,
      "${aws_s3_bucket.logging-bucket.arn}/*",
    ]

    effect = "Deny"

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"

      values = [
        "false"
      ]
    }
  }
  statement {
    sid = "allowRedshift"
    principals {
      type        = "Service"
      identifiers = ["redshift.amazonaws.com"]
    }

    actions = [
      "s3:GetBucketAcl",
      "s3:GetObjectAcl",
      "s3:PutBucketAcl",
      "s3:PutObject",
      "s3:GetObject",
      "s3:PutObjectAcl",
    ]
    resources = [
      aws_s3_bucket.logging-bucket.arn,
      "${aws_s3_bucket.logging-bucket.arn}/*",
    ]
  }
}

resource "aws_s3_bucket" "msk-source-landing-bucket" {
  bucket        = "msk-source-landing-bucket-${local.name_suffix}"
  force_destroy = true
  lifecycle {
    ignore_changes = [server_side_encryption_configuration, lifecycle_rule]
  }
  tags = merge(
    { Name = "msk-source-landing-bucket-${local.name_suffix}" },
    local.tags
  )
}

resource "aws_s3_bucket_acl" "msk-source-landing-bucket_acl" {
  bucket = aws_s3_bucket.msk-source-landing-bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "msk-source-landing-bucket_sse" {
  bucket = aws_s3_bucket.msk-source-landing-bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "msk-source-landing-bucket_versioning" {
  bucket = aws_s3_bucket.msk-source-landing-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "msk-source-landing-bucket_pab" {
  bucket                  = aws_s3_bucket.msk-source-landing-bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

}


resource "aws_s3_bucket_policy" "msk-source-landing-bucket-policy-attach" {
  bucket = aws_s3_bucket.msk-source-landing-bucket.id
  policy = data.aws_iam_policy_document.msk-source-landing-bucket-policy.json
}

data "aws_iam_policy_document" "msk-source-landing-bucket-policy" {
  statement {
    sid = "ssl-required"
    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:*"
    ]

    resources = [
      aws_s3_bucket.msk-source-landing-bucket.arn,
      "${aws_s3_bucket.msk-source-landing-bucket.arn}/*",
    ]

    effect = "Deny"

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"

      values = [
        "false"
      ]
    }
  }
}

resource "aws_s3_bucket" "historical-source-landing-bucket" {
  bucket        = "historical-source-landing-bucket-${local.name_suffix}"
  force_destroy = true
  lifecycle {
    ignore_changes = [server_side_encryption_configuration, lifecycle_rule]
  }
  tags = merge(
    { Name = "historical-source-landing-bucket-${local.name_suffix}" },
    local.tags
  )
}

resource "aws_s3_bucket_acl" "historical-source-landing-bucket_acl" {
  bucket = aws_s3_bucket.historical-source-landing-bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "historical-source-landing-bucket_sse" {
  bucket = aws_s3_bucket.historical-source-landing-bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "historical-source-landing-bucket_versioning" {
  bucket = aws_s3_bucket.historical-source-landing-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "historical-source-landing-bucket_pab" {
  bucket                  = aws_s3_bucket.historical-source-landing-bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

}


resource "aws_s3_bucket_policy" "historical-source-landing-bucket-policy-attach" {
  bucket = aws_s3_bucket.historical-source-landing-bucket.id
  policy = data.aws_iam_policy_document.historical-source-landing-bucket-policy.json
}

data "aws_iam_policy_document" "historical-source-landing-bucket-policy" {
  statement {
    sid = "ssl-required"
    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:*"
    ]

    resources = [
      aws_s3_bucket.historical-source-landing-bucket.arn,
      "${aws_s3_bucket.historical-source-landing-bucket.arn}/*",
    ]

    effect = "Deny"

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"

      values = [
        "false"
      ]
    }
  }
}

resource "aws_s3_bucket" "unclean-staging-bucket" {
  bucket        = "unclean-staging-bucket-${local.name_suffix}"
  force_destroy = true
  lifecycle {
    ignore_changes = [server_side_encryption_configuration, lifecycle_rule]
  }
  tags = merge(
    { Name = "unclean-staging-bucket-${local.name_suffix}" },
    local.tags
  )
}

resource "aws_s3_bucket_acl" "unclean-staging-bucket_acl" {
  bucket = aws_s3_bucket.unclean-staging-bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "unclean-staging-bucket_sse" {
  bucket = aws_s3_bucket.unclean-staging-bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "unclean-staging-bucket_versioning" {
  bucket = aws_s3_bucket.unclean-staging-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "unclean-staging-bucket_pab" {
  bucket                  = aws_s3_bucket.unclean-staging-bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

}


resource "aws_s3_bucket_policy" "unclean-staging-bucket-policy-attach" {
  bucket = aws_s3_bucket.unclean-staging-bucket.id
  policy = data.aws_iam_policy_document.unclean-staging-bucket-policy.json
}

data "aws_iam_policy_document" "unclean-staging-bucket-policy" {
  statement {
    sid = "ssl-required"
    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:*"
    ]

    resources = [
      aws_s3_bucket.unclean-staging-bucket.arn,
      "${aws_s3_bucket.unclean-staging-bucket.arn}/*",
    ]

    effect = "Deny"

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"

      values = [
        "false"
      ]
    }
  }
}

resource "aws_s3_bucket" "flagged-staging-bucket" {
  bucket        = "flagged-staging-bucket-${local.name_suffix}"
  force_destroy = true
  lifecycle {
    ignore_changes = [server_side_encryption_configuration, lifecycle_rule]
  }
  tags = merge(
    { Name = "flagged-staging-bucket-${local.name_suffix}" },
    local.tags
  )
}

resource "aws_s3_bucket_acl" "flagged-staging-bucket_acl" {
  bucket = aws_s3_bucket.flagged-staging-bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "flagged-staging-bucket_sse" {
  bucket = aws_s3_bucket.flagged-staging-bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "flagged-staging-bucket_versioning" {
  bucket = aws_s3_bucket.flagged-staging-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "flagged-staging-bucket_pab" {
  bucket                  = aws_s3_bucket.flagged-staging-bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

}


resource "aws_s3_bucket_policy" "flagged-staging-bucket-policy-attach" {
  bucket = aws_s3_bucket.flagged-staging-bucket.id
  policy = data.aws_iam_policy_document.flagged-staging-bucket-policy.json
}

data "aws_iam_policy_document" "flagged-staging-bucket-policy" {
  statement {
    sid = "ssl-required"
    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:*"
    ]

    resources = [
      aws_s3_bucket.flagged-staging-bucket.arn,
      "${aws_s3_bucket.flagged-staging-bucket.arn}/*",
    ]

    effect = "Deny"

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"

      values = [
        "false"
      ]
    }
  }
}

resource "aws_s3_bucket" "cleansed-staging-bucket" {
  bucket        = "cleansed-staging-bucket-${local.name_suffix}"
  force_destroy = true
  lifecycle {
    ignore_changes = [server_side_encryption_configuration, lifecycle_rule]
  }
  tags = merge(
    { Name = "cleansed-staging-bucket-${local.name_suffix}" },
    local.tags
  )
}

resource "aws_s3_bucket_acl" "cleansed-staging-bucket_acl" {
  bucket = aws_s3_bucket.cleansed-staging-bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "cleansed-staging-bucket_sse" {
  bucket = aws_s3_bucket.cleansed-staging-bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "cleansed-staging-bucket_versioning" {
  bucket = aws_s3_bucket.cleansed-staging-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "cleansed-staging-bucket_pab" {
  bucket                  = aws_s3_bucket.cleansed-staging-bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

}


resource "aws_s3_bucket_policy" "cleansed-staging-bucket-policy-attach" {
  bucket = aws_s3_bucket.cleansed-staging-bucket.id
  policy = data.aws_iam_policy_document.cleansed-staging-bucket-policy.json
}

data "aws_iam_policy_document" "cleansed-staging-bucket-policy" {
  statement {
    sid = "ssl-required"
    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:*"
    ]

    resources = [
      aws_s3_bucket.cleansed-staging-bucket.arn,
      "${aws_s3_bucket.cleansed-staging-bucket.arn}/*",
    ]

    effect = "Deny"

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"

      values = [
        "false"
      ]
    }
  }
}

resource "aws_s3_bucket" "adhoc-staging-bucket" {
  bucket        = "adhoc-staging-bucket-${local.name_suffix}"
  force_destroy = true
  lifecycle {
    ignore_changes = [server_side_encryption_configuration, lifecycle_rule]
  }
  tags = merge(
    { Name = "adhoc-staging-bucket-${local.name_suffix}" },
    local.tags
  )
}

resource "aws_s3_bucket_acl" "adhoc-staging-bucket_acl" {
  bucket = aws_s3_bucket.adhoc-staging-bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "adhoc-staging-bucket_sse" {
  bucket = aws_s3_bucket.adhoc-staging-bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "adhoc-staging-bucket_versioning" {
  bucket = aws_s3_bucket.adhoc-staging-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "adhoc-staging-bucket_pab" {
  bucket                  = aws_s3_bucket.adhoc-staging-bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

}


resource "aws_s3_bucket_policy" "adhoc-staging-bucket-policy-attach" {
  bucket = aws_s3_bucket.adhoc-staging-bucket.id
  policy = data.aws_iam_policy_document.adhoc-staging-bucket-policy.json
}

data "aws_iam_policy_document" "adhoc-staging-bucket-policy" {
  statement {
    sid = "ssl-required"
    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:*"
    ]

    resources = [
      aws_s3_bucket.adhoc-staging-bucket.arn,
      "${aws_s3_bucket.adhoc-staging-bucket.arn}/*",
    ]

    effect = "Deny"

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"

      values = [
        "false"
      ]
    }
  }
}

resource "aws_s3_bucket" "failed-staging-bucket" {
  bucket        = "failed-staging-bucket-${local.name_suffix}"
  force_destroy = true
  lifecycle {
    ignore_changes = [server_side_encryption_configuration, lifecycle_rule]
  }
  tags = merge(
    { Name = "failed-staging-bucket-${local.name_suffix}" },
    local.tags
  )
}

resource "aws_s3_bucket_notification" "failed-staging-bucket_notification" {
  bucket = aws_s3_bucket.failed-staging-bucket.id

  topic {
    topic_arn     = aws_sns_topic.s3_put_event_sns_topic.arn
    events        = ["s3:ObjectCreated:*"]
  }
}

resource "aws_s3_bucket_acl" "failed-staging-bucket_acl" {
  bucket = aws_s3_bucket.failed-staging-bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "failed-staging-bucket_sse" {
  bucket = aws_s3_bucket.failed-staging-bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "failed-staging-bucket_versioning" {
  bucket = aws_s3_bucket.failed-staging-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "failed-staging-bucket_pab" {
  bucket                  = aws_s3_bucket.failed-staging-bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

}


resource "aws_s3_bucket_policy" "failed-staging-bucket-policy-attach" {
  bucket = aws_s3_bucket.failed-staging-bucket.id
  policy = data.aws_iam_policy_document.failed-staging-bucket-policy.json
}

data "aws_iam_policy_document" "failed-staging-bucket-policy" {
  statement {
    sid = "ssl-required"
    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:*"
    ]

    resources = [
      aws_s3_bucket.failed-staging-bucket.arn,
      "${aws_s3_bucket.failed-staging-bucket.arn}/*",
    ]

    effect = "Deny"

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"

      values = [
        "false"
      ]
    }
  }
}

resource "aws_s3_bucket" "scripts-bucket" {
  bucket        = "scripts-bucket-${local.name_suffix}"
  force_destroy = true
  lifecycle {
    ignore_changes = [server_side_encryption_configuration, lifecycle_rule]
  }
  tags = merge(
    { Name = "scripts-bucket-${local.name_suffix}" },
    local.tags
  )
}

resource "aws_s3_bucket_acl" "scripts-bucket_acl" {
  bucket = aws_s3_bucket.scripts-bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "scripts-bucket_sse" {
  bucket = aws_s3_bucket.scripts-bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "scripts-bucket_versioning" {
  bucket = aws_s3_bucket.scripts-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "scripts-bucket_pab" {
  bucket                  = aws_s3_bucket.scripts-bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

}


resource "aws_s3_bucket_policy" "scripts-bucket-policy-attach" {
  bucket = aws_s3_bucket.scripts-bucket.id
  policy = data.aws_iam_policy_document.scripts-bucket-policy.json
}

data "aws_iam_policy_document" "scripts-bucket-policy" {
  statement {
    sid = "ssl-required"
    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:*"
    ]

    resources = [
      aws_s3_bucket.scripts-bucket.arn,
      "${aws_s3_bucket.scripts-bucket.arn}/*",
    ]

    effect = "Deny"

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"

      values = [
        "false"
      ]
    }
  }
}

resource "aws_s3_bucket" "modeled-staging-bucket" {
  bucket        = "modeled-staging-bucket-${local.name_suffix}"
  force_destroy = true
  lifecycle {
    ignore_changes = [server_side_encryption_configuration, lifecycle_rule]
  }
  tags = merge(
    { Name = "modeled-staging-bucket-${local.name_suffix}" },
    local.tags
  )
}

resource "aws_s3_bucket_acl" "modeled-staging-bucket_acl" {
  bucket = aws_s3_bucket.modeled-staging-bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "modeled-staging-bucket_sse" {
  bucket = aws_s3_bucket.modeled-staging-bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "modeled-staging-bucket_versioning" {
  bucket = aws_s3_bucket.modeled-staging-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "modeled-staging-bucket_pab" {
  bucket                  = aws_s3_bucket.modeled-staging-bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

}


resource "aws_s3_bucket_policy" "modeled-staging-bucket-policy-attach" {
  bucket = aws_s3_bucket.modeled-staging-bucket.id
  policy = data.aws_iam_policy_document.modeled-staging-bucket-policy.json
}

data "aws_iam_policy_document" "modeled-staging-bucket-policy" {
  statement {
    sid = "ssl-required"
    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:*"
    ]

    resources = [
      aws_s3_bucket.modeled-staging-bucket.arn,
      "${aws_s3_bucket.modeled-staging-bucket.arn}/*",
    ]

    effect = "Deny"

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"

      values = [
        "false"
      ]
    }
  }
}

