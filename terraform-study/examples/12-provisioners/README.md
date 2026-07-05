# 12 - Provisioners & connections

Provisioners run extra steps around a resource's lifecycle:

- **local-exec** - run a command where Terraform runs.
- **remote-exec** - run commands on the created machine (needs a `connection`).
- **file** - copy a file to the remote machine (needs a `connection`).
- **connection** - SSH/WinRM details used by `file`/`remote-exec`.

Timing: default provisioners run at **creation**; `when = destroy` runs at
**destroy** time. `null_resource` with `triggers` runs provisioners without
managing real infrastructure.

> Provisioners are a last resort - they aren't tracked in state the way
> resource attributes are. Prefer `user_data`, cloud-init, or purpose-built
> resources where possible.
