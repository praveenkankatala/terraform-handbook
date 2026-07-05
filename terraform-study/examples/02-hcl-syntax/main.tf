# Example 02 - HCL configuration syntax
# Anatomy of a block:
#
#   <BLOCK TYPE> "<block label>" "<block label>" {   # e.g. resource "aws_instance" "web"
#     <IDENTIFIER> = <EXPRESSION>                     # an argument
#   }
#
# Block label count depends on the block type:
#   variable -> 1 label      resource -> 2 labels (type, name)

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

# Single-line comments use # (preferred) or //
// This is also a comment.

/*
  Multi-line comments are wrapped in slash-star ... star-slash.
*/

# resource = block type; "aws_instance" and "ec2_demo" = two block labels.
resource "aws_instance" "ec2_demo" {
  ami           = "ami-0abcdef1234567890" # argument (name = value)
  instance_type = "t2.micro"

  tags = {
    Name = "ec2-demo"
  }
}
