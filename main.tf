provider "aws" {
  region = var.region
}

# Get latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.instance_name_prefix}-vpc"
  }
}

# Subnet
resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = "${var.region}a"

  tags = {
    Name = "${var.instance_name_prefix}-subnet"
  }
}

# EC2 Instances with meta-arguments
resource "aws_instance" "example" {
  count         = var.instance_count
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.main.id

  depends_on = [
    aws_vpc.main,
    aws_subnet.main
  ]

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [tags["DeployedAt"]]
  }

  timeouts {
    create = "10m"
    delete = "10m"
  }

  tags = {
    Name        = "${var.instance_name_prefix}-${count.index + 1}"
    Environment = "Dev"
    DeployedAt  = timestamp()
  }
}
