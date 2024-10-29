variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "versioning" {
  description = "Should versioning be enabled?"
}

variable "environment" {
  description = "The environment (e.g., dev, prod) tag"
  type        = string
}

variable "tags" {
  description = "A map of tags to apply to the bucket"
  type        = map(string)
  default     = {}
}

