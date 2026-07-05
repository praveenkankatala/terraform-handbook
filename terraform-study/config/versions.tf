# ---------------------------------------------------------------------------
# config/versions.tf
# The `terraform` settings block: pins the Terraform CLI version and declares
# every provider the configuration needs (local name -> source + version).
# This is the first thing `terraform init` reads to build the dependency lock.
# ---------------------------------------------------------------------------

terraform {
  # Constrain the CLI version. `~> 1.9` means >= 1.9.0 and < 2.0.0.
  required_version = ">= 1.6.0, < 2.0.0"

  required_providers {
    # local name = { source = "<HOSTNAME>/<NAMESPACE>/<TYPE>", version = ... }
    # HOSTNAME defaults to registry.terraform.io when omitted.
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.60"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}
