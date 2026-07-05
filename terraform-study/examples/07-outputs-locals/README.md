# 07 - Outputs & locals

**Local values** implement DRY (Don't Repeat Yourself): assign a name to an
expression once (`locals { ... }`) and reuse it as `local.<name>`. The key
advantage is changing a value in one central place. Overuse can hide real
values and hurt readability, so use them judiciously.

**Output values** are a module's return values:
1. A root module prints them to the CLI after `apply`.
2. A child module exposes attributes to its parent.
3. With remote state, other configurations read them via `terraform_remote_state`.

- `sensitive = true` redacts an output from CLI output (not from state).
- `terraform output -json` produces machine-readable output for scripts.
