# Example 09 - State & backends.
# State maps real-world resources to your configuration and is stored by
# default in a LOCAL file (terraform.tfstate). For teams, use a REMOTE backend
# so everyone shares one state and state LOCKING prevents concurrent writes.

terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.60"
    }
  }

  # Uncomment to enable a remote S3 backend (see backend.tf.example in /config).
  # backend "s3" {
  #   bucket       = "my-org-terraform-state"
  #   key          = "study/terraform.tfstate"
  #   region       = "us-east-1"
  #   encrypt      = true
  #   use_lockfile = true   # native S3 locking (Terraform >= 1.10)
  # }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "my_ec2_vm" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "t2.micro"
  tags          = { Name = "my-ec2-vm" }
}
