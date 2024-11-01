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



resource "aws_iam_role" "terraform_deployer_role" {
  name               = "TerraformDeployerRole"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "terraform_deployer_policy" {
  name        = "TerraformDeployerPolicy"
  description = "Policy to allow deployment of S3, VPC, EKS, roles, and policies via Terraform"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:*",
        "vpc:*"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "eks:*"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "iam:CreateRole",
        "iam:AttachRolePolicy",
        "iam:PutRolePolicy",
        "iam:DeleteRole",
        "iam:DetachRolePolicy",
        "iam:DeleteRolePolicy",
        "iam:GetRole",
        "iam:PassRole"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.terraform_deployer_role.name
  policy_arn = aws_iam_policy.terraform_deployer_policy.arn
}