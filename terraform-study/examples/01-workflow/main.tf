# Example 01 - The core Terraform workflow: init -> validate -> plan -> apply -> destroy
# This example uses the `random` provider so it runs with ZERO cloud credentials.

terraform {
  required_version = ">= 1.6.0"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

# A trivial resource so `apply` actually creates something in state.
resource "random_pet" "server" {
  length    = 2
  separator = "-"
}

output "server_name" {
  value = random_pet.server.id
}
