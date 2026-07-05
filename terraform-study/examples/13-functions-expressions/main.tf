# Example 13 - Built-in functions and expressions.
# Explore any of these interactively with:  terraform console

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

variable "environment" {
  type    = string
  default = "dev"
}

variable "azs" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

locals {
  # length(): number of elements in a string/list/map.
  az_count = length(var.azs) # -> 3

  # substr(string, offset, length): extract a substring.
  region_prefix = substr(var.azs[0], 0, 9) # -> "us-east-1"

  # file(): read a file's contents as a string (e.g. read greeting.txt).
  greeting = fileexists("${path.module}/greeting.txt") ? file("${path.module}/greeting.txt") : "hello"

  # Conditional (ternary) expression.
  instance_type = var.environment == "prod" ? "t3.large" : "t3.micro"

  # for expression: transform a list into a new list.
  upper_azs = [for az in var.azs : upper(az)]

  # for expression building a map.
  az_index = { for idx, az in var.azs : az => idx }
}

# Create one subnet per AZ using count + the length() above.
resource "aws_subnet" "public" {
  count             = local.az_count
  vpc_id            = aws_vpc.main.id
  availability_zone = var.azs[count.index]
  cidr_block        = cidrsubnet("10.0.0.0/16", 8, count.index) # cidrsubnet() function
  tags              = { Name = "public-${var.azs[count.index]}" }
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

# dynamic block: generate repeated nested blocks (here, ingress rules) from data.
resource "aws_security_group" "web" {
  name   = "web-${var.environment}"
  vpc_id = aws_vpc.main.id

  dynamic "ingress" {
    for_each = { http = 80, https = 443 }
    content {
      description = ingress.key
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

output "region_prefix" {
  value = local.region_prefix
}
