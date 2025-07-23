provider "aws" {
  region = "us-west-1"
}
 
# EC2 instances
resource "aws_instance" "examin" {
  count         = 3
  ami           = "ami-0a0409af1cb831414"
  instance_type = "t2.micro"
 
  tags = {
    Name = "MyEC2Instance-${count.index + 1}"
  }
}
 
# Output the public IPs of the instances
output "instance_public_ips" {
  value = aws_instance.examin[*].public_ip
}
