# Example 03 - Providers: requirements, source, local names, and aliases.

terraform {
  required_version = ">= 1.6.0"
  required_providers {
    # "aws" is the LOCAL NAME. source = <HOSTNAME>/<NAMESPACE>/<TYPE>.
    # HOSTNAME defaults to registry.terraform.io. The local name must match
    # the label used in every provider/resource reference below.
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.60"
    }
  }
}

# Default provider configuration for us-east-1.
provider "aws" {
  region = "us-east-1"
}

# An ALIASED provider for a second region. The primary reason for multiple
# provider configs is supporting multiple regions of one cloud platform.
provider "aws" {
  alias  = "west"
  region = "us-west-1"
}

# Uses the default provider (us-east-1).
resource "aws_vpc" "east" {
  cidr_block = "10.1.0.0/16"
  tags       = { Name = "vpc-us-east-1" }
}

# Selects the aliased provider with the `provider` meta-argument:
#   provider = <LOCAL NAME>.<ALIAS>
resource "aws_vpc" "west" {
  provider   = aws.west
  cidr_block = "10.2.0.0/16"
  tags       = { Name = "vpc-us-west-1" }
}
