# Example 11 - Modules: the ROOT module calls a CHILD module.
# A module is a container for multiple resources used together. The root module
# is the working directory where you run terraform; it calls child modules with
# a `module` block, passing input variables and consuming their outputs.

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

# Local module source. Could also be a registry ("terraform-aws-modules/ec2-instance/aws")
# or a Git URL, optionally pinned with `version` for registry modules.
module "web" {
  source = "./modules/ec2-instance"

  name          = "web-server"
  ami_id        = "ami-0abcdef1234567890"
  instance_type = "t3.micro"
  tags          = { Environment = "dev" }
}

# count/for_each also work on module blocks (Terraform >= 0.13).
module "workers" {
  source   = "./modules/ec2-instance"
  for_each = toset(["worker-a", "worker-b"])

  name   = each.key
  ami_id = "ami-0abcdef1234567890"
}

# Consume a child module output as module.<NAME>.<OUTPUT>.
output "web_instance_id" {
  value = module.web.instance_id
}
