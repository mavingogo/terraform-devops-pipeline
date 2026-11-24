provider "aws" {
  region = "us-east-1"
}

resource "aws_kms_key" "s3_encryption" {
  description             = "KMS key for DevSecOps S3 encryption"
  enable_key_rotation     = true
  deletion_window_in_days = 30

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "EnableAccountRootPermissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      }
    ]
  })
}

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "secure_storage" {
  #checkov:skip=CKV2_AWS_62: Event notifications are outside the scope of this static demonstration.
  #checkov:skip=CKV_AWS_144: Cross-region replication is outside the scope of this no-deployment demonstration.

  bucket = "devsecops-demo-bucket-change-this-name"
}

resource "aws_s3_bucket_public_access_block" "secure_storage" {
  bucket = aws_s3_bucket.secure_storage.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "secure_storage" {
  bucket = aws_s3_bucket.secure_storage.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "secure_storage" {
  bucket = aws_s3_bucket.secure_storage.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.s3_encryption.arn
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "secure_storage" {
  bucket = aws_s3_bucket.secure_storage.id

  rule {
    id     = "expire-old-objects"
    status = "Enabled"

    filter {}

    expiration {
      days = 365
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

resource "aws_s3_bucket" "access_logs" {
  #checkov:skip=CKV2_AWS_62: Event notifications are outside the scope of this static demonstration.
  #checkov:skip=CKV_AWS_144: Cross-region replication is outside the scope of this no-deployment demonstration.
  #checkov:skip=CKV_AWS_145: S3 server access log destination buckets require SSE-S3 rather than SSE-KMS.

  bucket = "devsecops-demo-access-logs-change-this-name"
}

# Prevent public access to the logging bucket
resource "aws_s3_bucket_public_access_block" "access_logs" {
  bucket = aws_s3_bucket.access_logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Send access logs from the main bucket to the logging bucket
resource "aws_s3_bucket_logging" "secure_storage" {
  bucket        = aws_s3_bucket.secure_storage.id
  target_bucket = aws_s3_bucket.access_logs.id
  target_prefix = "s3-access-logs/"
}

# Enable versioning for the access logs bucket
resource "aws_s3_bucket_versioning" "access_logs" {
  bucket = aws_s3_bucket.access_logs.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Manage retention of access logs
resource "aws_s3_bucket_lifecycle_configuration" "access_logs" {
  bucket = aws_s3_bucket.access_logs.id

  rule {
    id     = "expire-old-access-logs"
    status = "Enabled"

    filter {}

    expiration {
      days = 365
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}
