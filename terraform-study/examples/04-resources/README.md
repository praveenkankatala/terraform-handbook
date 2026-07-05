# 04 - Resources & resource behavior

A `resource` block declares one infrastructure object. On each run Terraform
diffs desired vs current state and picks an action:

| Action | When |
|--------|------|
| Create | resource is in config but not in state |
| Destroy | resource is in state but removed from config |
| Update in-place | changed arguments can be patched on the live object |
| Destroy & re-create | changed arguments force replacement (shown as `-/+`) |

`terraform fmt` rewrites configuration files to the canonical format (run it
before committing; the CI checks it with `terraform fmt -check`).
