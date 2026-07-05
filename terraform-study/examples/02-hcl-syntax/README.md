# 02 - HCL syntax

Terraform code lives in plain-text `.tf` files (there is also a JSON variant,
`.tf.json`). The building blocks of the language are **blocks**, **arguments**,
**identifiers**, and **comments**.

- **Block**: `<BLOCK TYPE> "<label>" ... { body }`
- **Argument**: `identifier = expression` inside a block body
- **Attribute**: a value exposed by a resource, referenced as
  `<resource_type>.<name>.<attribute>`
- **Comments**: `#`, `//` (single line), `/* ... */` (multi-line)
