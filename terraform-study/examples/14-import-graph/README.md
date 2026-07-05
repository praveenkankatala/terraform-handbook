# 14 - Import & graph

## terraform import

Bring existing infrastructure under Terraform management by importing its state.

```bash
# 1) Write a resource block that matches the real object (see main.tf).
# 2) Import the real object's ID into state:
terraform import aws_instance.my_instance i-0abc123def456
# 3) Reconcile:
terraform plan   # config may still be incomplete; adjust until plan is clean
```

`terraform import` updates only the **state file**, not your `.tf` files.

## terraform graph

Generate a visual dependency graph in DOT format, then render it with Graphviz:

```bash
terraform graph > graph.dot
dot -Tpng graph.dot -o graph.png   # or -Tsvg / -Tpdf
```

Useful for understanding relationships, debugging ordering, and validating
dependency management.
