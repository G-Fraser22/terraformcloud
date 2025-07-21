# S3 bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-unique-bucket-name-s3gina"  # Replace with a globally unique name
 
  tags = {
    Name = "My S3 Bucket"
  }
}