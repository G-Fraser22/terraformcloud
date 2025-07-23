provider "aws" {
  region = "us-west-1"  # Change to your desired region
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-unique-bucket-name-ginafraser1"  # Must be globally unique

  tags = {
    Name        = "MyS3Bucket"
    Environment = "Dev"
  }
}
