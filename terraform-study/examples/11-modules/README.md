# 11 - Modules

A **module** is a reusable container of resources. The **root module** is your
working directory; it calls **child modules** via `module` blocks.

- **Inputs**: pass values to a module's `variable`s as arguments in the block.
- **Outputs**: read a child's results with `module.<name>.<output>`.
- **Sources**: local path (`./modules/...`), Terraform Registry
  (`namespace/name/provider` + `version`), or a Git/HTTP URL.
- `count` and `for_each` work on module blocks too.

```bash
terraform init   # also installs modules into .terraform/modules
terraform plan
```
