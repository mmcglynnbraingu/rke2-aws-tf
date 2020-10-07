resource "aws_s3_bucket" "bucket" {
  bucket = lower("${var.name}-rke2")
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
      }
    }
  }

  tags = merge({}, var.tags)
}

resource "aws_s3_bucket_object" "token" {
  bucket       = aws_s3_bucket.bucket.id
  key          = "token"
  content_type = "text/plain"
  content      = var.token
}

data "aws_iam_policy_document" "getter" {
  statement {
    effect  = "Allow"
    actions = ["s3:GetObject"]
    resources = [
      aws_s3_bucket.bucket.arn
    ]
  }
}
