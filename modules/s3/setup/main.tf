provider "aws" {
  region = "us-east-1"
}
module "s3" {
  source = "../"
  bucket_name = "test-terraform-state-s3-fonka"
  environment =  "test"
  tags = {}
  versioning = "Enabled"
}