# Example 04 - Resources and resource behavior.
#
# Terraform maps the desired state (your .tf files) to the current state
# (what exists in the cloud) and computes one of four actions per resource:
#   * create            - in config, not yet in state
#   * destroy           - in state, removed from config
#   * update in-place    - arguments changed and can be patched live
#   * destroy & recreate - arguments changed but cannot be updated in-place (+/-)

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
  ami           = "ami-0abcdef1234567890"
  instance_type = "t2.micro" # change to t3.micro -> update or replace

  tags = {
    Name = "web-server"
  }
}

# Run `terraform fmt` to rewrite files into the canonical Terraform style.
