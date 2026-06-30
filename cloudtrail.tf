resource "aws_s3_bucket" "cloudtrail" {

  bucket        = "cloudtrail-logs-${data.aws_caller_identity.current.account_id}"

  force_destroy = true # lets `terraform destroy` empty the bucket — lab convenience only

}

resource "aws_s3_bucket_public_access_block" "cloudtrail" {

  bucket                  = aws_s3_bucket.cloudtrail.id

  block_public_acls       = true

  block_public_policy     = true

  ignore_public_acls      = true

  restrict_public_buckets = true

}

resource "aws_s3_bucket_server_side_encryption_configuration" "cloudtrail" {

  bucket = aws_s3_bucket.cloudtrail.id

  rule {

    apply_server_side_encryption_by_default {

      sse_algorithm = "AES256"

    }

  }

}

data "aws_iam_policy_document" "cloudtrail_bucket" {

  statement {

    sid     = "AWSCloudTrailAclCheck"

    effect  = "Allow"

    principals {

      type        = "Service"

      identifiers = ["cloudtrail.amazonaws.com"]

    }

    actions   = ["s3:GetBucketAcl"]

    resources = [aws_s3_bucket.cloudtrail.arn]

  }

  statement {

    sid     = "AWSCloudTrailWrite"

    effect  = "Allow"

    principals {

      type        = "Service"

      identifiers = ["cloudtrail.amazonaws.com"]

    }

    actions   = ["s3:PutObject"]

    resources = ["${aws_s3_bucket.cloudtrail.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"]

    condition {

      test     = "StringEquals"

      variable = "s3:x-amz-acl"

      values   = ["bucket-owner-full-control"]

    }

  }

}

resource "aws_s3_bucket_policy" "cloudtrail" {

  bucket = aws_s3_bucket.cloudtrail.id

  policy = data.aws_iam_policy_document.cloudtrail_bucket.json

}

resource "aws_cloudtrail" "main" {

  name                          = "account-baseline-trail"

  s3_bucket_name                = aws_s3_bucket.cloudtrail.id

  is_multi_region_trail         = true

  include_global_service_events = true

  enable_log_file_validation    = true

  depends_on = [aws_s3_bucket_policy.cloudtrail] # trail creation fails without the policy in place

}

