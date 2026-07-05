# Example 07 - Output values and local values.

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

# ---- locals: follow DRY, name an expression, reference as local.<name> -----
locals {
  service_name = "forum"
  owner        = "Community Team"

  common_tags = {
    Service = local.service_name
    Owner   = local.owner
  }
}

resource "aws_instance" "example" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "t2.micro"
  tags          = local.common_tags
}

# ---- outputs: like a module's return values --------------------------------
output "ec2_instance_public_ip" {
  description = "EC2 instance Public IP"
  value       = aws_instance.example.public_ip
}

# Sensitive output: redacted from `plan`/`apply` CLI output. `terraform output`
# can still reveal it, and the value remains in state.
output "ec2_instance_private_ip" {
  description = "EC2 instance Private IP"
  value       = aws_instance.example.private_ip
  sensitive   = true
}
