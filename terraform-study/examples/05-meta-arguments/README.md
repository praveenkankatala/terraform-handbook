# 05 - Resource meta-arguments

| Meta-argument | Purpose |
|---------------|---------|
| `depends_on` | Declare a hidden dependency Terraform can't infer. Value is a list of references. |
| `count` | Create N copies; use `count.index` (0-based). |
| `for_each` | Create one instance per map/set member; use `each.key` / `each.value`. |
| `provider` | Select a non-default (aliased) provider configuration. |
| `lifecycle` | Alter standard behavior: `create_before_destroy`, `prevent_destroy`, `ignore_changes`. |

A single resource/module block **cannot** use both `count` and `for_each`.
