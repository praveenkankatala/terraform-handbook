# 10 - Workspaces

A **workspace** lets you run multiple instances of one configuration within a
single project - each workspace has its own **state file**, so changes in one
don't affect others. Every project starts in the `default` workspace.

```bash
terraform workspace new Dev          # create
terraform workspace list             # list (current is marked *)
terraform workspace select Production  # switch
terraform workspace delete Dev       # delete (can't delete the active one)
```

Reference the active workspace with `terraform.workspace` to vary sizing,
tags, or counts per environment.
