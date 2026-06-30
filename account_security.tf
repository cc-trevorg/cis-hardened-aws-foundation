# Block ALL public S3 access at the account level (overrides per-bucket settings)

resource "aws_s3_account_public_access_block" "account" {

  block_public_acls       = true

  block_public_policy     = true

  ignore_public_acls      = true

  restrict_public_buckets = true

}

# Encrypt every new EBS volume by default

resource "aws_ebs_encryption_by_default" "default" {

  enabled = true

}

# CIS 1.20 — IAM Access Analyzer (free; flags resources shared outside the account)

resource "aws_accessanalyzer_analyzer" "account" {

  analyzer_name = "account-analyzer"

  type          = "ACCOUNT"

}

