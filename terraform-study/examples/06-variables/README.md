# 06 - Input variables

Ways to assign a variable (highest precedence last):

1. Environment variables: `export TF_VAR_ec2_count=3`
2. `terraform.tfvars` (auto-loaded)
3. `*.auto.tfvars` / `terraform.tfvars.json` (auto-loaded)
4. `-var` and `-var-file` on the command line

```bash
terraform plan -var="ec2_instance_types=[\"t3.large\"]" -var="ec2_count=1" -out v3out.plan
terraform apply v3out.plan
terraform plan -var-file="prod.tfvars"
```

**Complex types**: `list(string)`, `map(string)`, `object({...})`, `tuple([...])`.
**Validation** blocks reject bad input early. **`sensitive = true`** redacts a
value from output - but note the value still lands in the state file, so keep
state secure and never commit real `*.tfvars` secrets.
