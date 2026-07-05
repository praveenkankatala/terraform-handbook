# 03 - Providers

A **provider** is the heart of Terraform: every resource type (e.g.
`aws_instance`) is implemented by a provider. Providers are distributed
separately from Terraform, each with its own version numbers, and published to
the **Terraform Registry** (`registry.terraform.io`).

Registry tiers: **official** (HashiCorp), **partner/verified** (third parties,
authenticity verified by HashiCorp), **community**, and **archived**.

- **required_providers** pins `source` + `version` inside the `terraform` block.
- **Local name** is how you refer to a provider; keep it consistent everywhere.
- **Source address** = `<HOSTNAME>/<NAMESPACE>/<TYPE>` (hostname optional).
- **Aliases** let you configure the same provider multiple times (e.g. regions)
  and select one per resource via `provider = aws.<alias>`.
