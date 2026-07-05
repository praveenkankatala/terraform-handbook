# Example 10 - Workspaces: manage multiple instances of the SAME configuration,
# each with its OWN state file. terraform.workspace holds the active name.

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

# Pick a bigger box in Production, a small one everywhere else.
resource "aws_instance" "example" {
  ami           = "ami-0abcdef1234567890"
  instance_type = terraform.workspace == "Production" ? "t3.large" : "t3.micro"

  tags = {
    Name = "my-instance-${terraform.workspace}"
  }
}
