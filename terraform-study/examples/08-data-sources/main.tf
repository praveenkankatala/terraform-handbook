# Example 08 - Data sources: fetch/compute data defined OUTSIDE this config
# (e.g. created manually, by another tool, or by a separate Terraform config).

terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.60"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# A data resource is declared with a `data` block. This one looks up the latest
# Amazon Linux 2 AMI instead of hardcoding an AMI ID.
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Reference a data source as data.<TYPE>.<NAME>.<ATTRIBUTE>.
resource "aws_instance" "web" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  tags          = { Name = "web-from-data-source" }
}

output "resolved_ami_id" {
  value = data.aws_ami.amazon_linux.id
}
