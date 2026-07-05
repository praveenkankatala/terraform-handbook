# Example 14 - Importing existing infra + visualizing the dependency graph.

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

# To adopt an EXISTING instance you first write a matching resource block,
# then import the real object's ID into state (see README). `terraform import`
# updates STATE only - it does not generate this block for you.
resource "aws_instance" "my_instance" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "t2.micro"
  tags          = { Name = "adopted-instance" }
}

# Terraform >= 1.5 can also import declaratively with an import block, and
# generate starter config via `terraform plan -generate-config-out=gen.tf`.
# import {
#   to = aws_instance.my_instance
#   id = "i-0abc123def456"
# }
