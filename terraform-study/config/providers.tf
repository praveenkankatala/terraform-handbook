# ---------------------------------------------------------------------------
# config/providers.tf
# Provider configuration. A provider is the plugin that implements each
# resource type (aws_instance, aws_vpc, ...). Credentials are NEVER hardcoded
# here: the AWS provider reads them from the environment / shared config file.
# ---------------------------------------------------------------------------

# Default AWS provider. Region is taken from a variable so it stays portable.
provider "aws" {
  region = var.aws_region

  # `profile` reads credentials from ~/.aws/credentials (recommended locally).
  # In CI, prefer environment variables (AWS_ACCESS_KEY_ID / AWS_SECRET_ACCESS_KEY)
  # or an OIDC-assumed role so nothing sensitive lives in the repo.
  profile = var.aws_profile

  default_tags {
    tags = {
      ManagedBy = "Terraform"
      Repo      = "terraform-study"
    }
  }
}

# A second, ALIASED provider for a different region. Reference it explicitly
# in a resource with `provider = aws.use_west`.
provider "aws" {
  alias   = "use_west"
  region  = "us-west-1"
  profile = var.aws_profile
}

variable "aws_region" {
  description = "Primary AWS region for the default provider."
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "Named profile in ~/.aws/credentials. Leave null to use env vars."
  type        = string
  default     = null
}
