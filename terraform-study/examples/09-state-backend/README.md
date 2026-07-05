# 09 - State & backends

Terraform stores **state** to map real resources to your config, track
metadata, and speed up large infrastructures. Default is a local
`terraform.tfstate`; a **remote backend** works better for teams.

**Backends** do three things: store state, provide state locking, and (for some)
perform operations. Only two backends actually run operations: `local` and
`remote`.

**State locking** prevents concurrent writes. AWS S3 supports locking (native
lockfile on Terraform >= 1.10, or a DynamoDB table on older versions). Locking
happens automatically on any state-writing operation.

## State inspection & manipulation commands

```bash
terraform refresh                       # detect drift; update state (not infra)
terraform state list                    # list resources in state
terraform state show aws_instance.my_ec2_vm
terraform state mv SOURCE DEST          # rename/move (DANGEROUS - back up first)
terraform state rm aws_instance.my_ec2_vm   # forget a resource (leaves infra)
terraform state pull > backup.tfstate   # download remote state to stdout
terraform state push terraform.tfstate  # upload a local state to remote
terraform state replace-provider OLD NEW
terraform force-unlock LOCK_ID          # release a stuck lock (last resort)
terraform taint aws_instance.my_ec2_vm    # mark for destroy+recreate next apply
terraform untaint aws_instance.my_ec2_vm  # undo a taint
```

> `terraform state mv` and `rm` change state without touching real infra - take
> a backup (`terraform state pull`) first, and rehearse in a lower environment.
