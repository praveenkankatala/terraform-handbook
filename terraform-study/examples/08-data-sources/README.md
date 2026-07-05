# 08 - Data sources

Data sources let a configuration **read** information defined elsewhere. A data
resource is declared with a `data` block and referenced as
`data.<type>.<name>.<attribute>`.

- Data resources share the same dependency-resolution behavior as managed
  resources (a `depends_on` inside a data block defers the read until after
  dependencies settle).
- They support the provider meta-argument and `count` / `for_each`, but have no
  `lifecycle` customization today.

Typical use: resolve the latest AMI, an existing VPC, or another team's outputs.
