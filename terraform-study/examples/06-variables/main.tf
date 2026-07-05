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

resource "aws_instance" "web" {
  count         = var.ec2_count
  ami           = var.ec2_ami_id
  instance_type = var.ec2_instance_types[0] # index 0 -> first element
  tags          = merge(var.common_tags, { Name = "web-${count.index}" })
}
