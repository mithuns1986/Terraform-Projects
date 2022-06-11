provider "aws" {

  region = "us-east-1"
}


terraform {
  backend "s3" {
    bucket         = "terraform-microdegree"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
  }
}

resource "aws_s3_bucket" "example" {
  bucket = "my-tf-elb-bucket"
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.example.id
  policy = data.aws_iam_policy_document.allow_access_from_another_account.json
}

data "aws_iam_policy_document" "allow_access_from_another_account" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["127311923021"]
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
      "s3:PutObject",
    ]

    resources = [
      aws_s3_bucket.example.arn,
      "${aws_s3_bucket.example.arn}/*",
    ]
  }
}

resource "aws_lb" "test" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  #security_groups    = [aws_security_group.lb_sg.id]
  subnets            = ["subnet-04f60e993d93d8af7" , "subnet-067a8d0e09f614ba8"]

  enable_deletion_protection = true

  access_logs {
    bucket  = aws_s3_bucket.example.id
    prefix  = "logs-lb"
    enabled = true
  }

  tags = {
    Environment = "production"
  }
}
