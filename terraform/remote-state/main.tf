locals {
  prefix = lower("${var.project}-${var.environment}")
}

resource "random_string" "suffix" {
  length = 12
  special = false
  upper = false
}

resource "aws_s3_bucket" "tfstate" {
  bucket = "${local.prefix}-tfstate-${random_string.suffix.result}"
  lifecycle {
    prevent_destroy = true
  }
  tags = {
    Name = "${local.prefix}-tfstate-${random_string.suffix.result}"
    Project = "${local.prefix}"
  }
}

resource "aws_s3_bucket_versioning" "tfstate" {
    bucket = aws_s3_bucket.tfstate.id
    versioning_configuration {
      status = "Enabled"
    }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate" {
  bucket = aws_s3_bucket.tfstate.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_dynamodb_table" "tfstate-lock" {
  name         = "${local.prefix}-tfstate-lock"
  hash_key     = "LockID"
  read_capacity  = 5
  write_capacity = 5
  attribute {
    name = "LockID"
    type = "S"
  }
  lifecycle {
    prevent_destroy = true
  }
  tags = {
    Name = "${local.prefix}-tfstate-lock"
    Project = "${local.prefix}"
  }
}
