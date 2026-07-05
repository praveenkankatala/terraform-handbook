# Example 05 - Resource meta-arguments.
# Meta-arguments work on ANY resource type and change its behavior:
#   depends_on, count, for_each, provider, lifecycle.

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

# ---- count -----------------------------------------------------------------
# Create N instances indexed 0..N-1. count.index is the 0-based instance index.
resource "aws_instance" "web" {
  count         = 3
  ami           = "ami-0abcdef1234567890"
  instance_type = "t2.micro"

  tags = {
    Name = "web-${count.index}" # web-0, web-1, web-2
  }
}

# ---- for_each (set of strings) ---------------------------------------------
# One instance per set member. each.key == each.value for a set.
resource "aws_instance" "named" {
  for_each      = toset(["jack", "james"])
  ami           = "ami-0abcdef1234567890"
  instance_type = "t2.micro"

  tags = {
    Name = each.key # jack, james
  }
}

# ---- for_each (map) --------------------------------------------------------
# each.key = map key, each.value = map value.
resource "aws_s3_bucket" "buckets" {
  for_each = {
    dev  = "my-app-dev-bucket"
    prod = "my-app-prod-bucket"
  }
  bucket = each.value
  tags   = { Env = each.key }
}

# ---- depends_on ------------------------------------------------------------
# Explicit dependency for relationships Terraform cannot infer automatically.
resource "aws_eip" "web" {
  domain     = "vpc"
  depends_on = [aws_instance.web]
}

# ---- lifecycle -------------------------------------------------------------
resource "aws_instance" "critical" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "t2.micro"

  lifecycle {
    create_before_destroy = true          # make the new one before killing the old
    prevent_destroy       = false          # set true to guard costly objects (e.g. DBs)
    ignore_changes        = [tags["Name"]] # ignore drift on these attributes
  }
}

# NOTE: a given block cannot use BOTH count and for_each.
