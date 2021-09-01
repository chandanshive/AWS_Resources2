provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "webserver" {
  ami           = "ami-01e36b7901e884a10"
  instance_type = "t2.micro"

  tags = {
    Name = "webserver"
  }

  metadata_options {
    http_endpoint = "disabled"
    http_tokens   = "required"
  }
  monitoring = true
}

resource "aws_s3_bucket" "accuricsbucketdemo" {
  bucket = "my-tf-test-bucket"

  tags = {
    Name = "bucketdemo"
  }

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_vpc" "<resource_name>" {
  cidr_block = "<cidr>"

  tags = {
    Name = "main"
  }
}
resource "aws_s3_bucket_policy" "accuricsbucketdemoPolicy" {
  bucket = "${aws_s3_bucket.accuricsbucketdemo.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "accuricsbucketdemo-restrict-access-to-users-or-roles",
      "Effect": "Allow",
      "Principal": [
        {
          "AWS": [
            "arn:aws:iam::##acount_id##:role/##role_name##",
            "arn:aws:iam::##acount_id##:user/##user_name##"
          ]
        }
      ],
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.accuricsbucketdemo.id}/*"
    }
  ]
}
POLICY
}