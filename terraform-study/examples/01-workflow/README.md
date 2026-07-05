# 01 - Terraform workflow

Run these in order:

```bash
terraform init      # download providers, create .terraform + lock file
terraform validate  # check syntax + internal consistency
terraform plan      # show the execution plan (refresh + diff to desired state)
terraform apply      # apply changes, write to terraform.tfstate
terraform destroy   # tear down everything Terraform manages
```

No AWS account needed - the `random` provider is local.
