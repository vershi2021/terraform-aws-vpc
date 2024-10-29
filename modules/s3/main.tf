resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  tags   = var.tags
}

resource "aws_s3_bucket_versioning" "name" {
  count =  length(var.versioning) > 0 ? 1 : 0
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = var.versioning
  }
}
