# Example 06 - Input variables (parameters for a module).

# Simple variable with a default. If no value is supplied, the default is used.
variable "ec2_count" {
  description = "EC2 instance count"
  type        = number
  default     = 1
}

# Complex type: list of strings.
variable "ec2_instance_types" {
  description = "Candidate EC2 instance types"
  type        = list(string)
  default     = ["t2.micro", "t2.small", "t2.large"]
}

# Complex type: map (an object of key/value pairs).
variable "common_tags" {
  description = "Tags applied to every resource"
  type        = map(string)
  default = {
    Environment = "dev"
    Owner       = "platform-team"
  }
}

# Custom validation: fail fast with a clear message on bad input.
variable "ec2_ami_id" {
  description = "AMI ID"
  type        = string
  default     = "ami-0abcdef1234567890"

  validation {
    condition     = length(var.ec2_ami_id) > 4 && substr(var.ec2_ami_id, 0, 4) == "ami-"
    error_message = "The ec2_ami_id value must start with \"ami-\"."
  }
}

# Sensitive variable: Terraform redacts it from CLI/plan output. Supply the
# value via an environment variable (export TF_VAR_db_password=...), never in
# a committed file.
variable "db_password" {
  description = "Database password (provide via TF_VAR_db_password)"
  type        = string
  sensitive   = true
  default     = null
}
