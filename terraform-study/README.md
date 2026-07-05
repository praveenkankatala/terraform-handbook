# Terraform - Zero to Production Study Guide

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./terraform-handbook/LICENSE)
[![Terraform CI](https://github.com/<your-github-username>/terraform-study/actions/workflows/terraform-ci.yml/badge.svg)](https://github.com/<your-github-username>/terraform-study/actions/workflows/terraform-ci.yml)

A complete, hands-on study repository for **Terraform** - the open-source
Infrastructure-as-Code (IaC) tool. Every topic below has concise theory, a
**copy-paste runnable** code block, and a matching example under
[`examples/`](./examples). Code targets current Terraform (**1.6+**) and the
AWS provider (**~> 5.x**) using idiomatic, production-oriented patterns.

> Terraform doesn't only create resources - it also **maintains** them. It
> records what it creates in real-world cloud environments in its **state file**.

---

## Repository structure

```text
terraform-study/
├── README.md                     # this study guide
├── LICENSE                       # MIT (edit <Your Name>)
├── .gitignore                    # Terraform-aware ignores (keeps secrets/state out)
├── config/                       # real starter files a Terraform project needs
│   ├── versions.tf               # terraform{} block + required_providers
│   ├── providers.tf              # provider config + aliases (no secrets)
│   ├── backend.tf.example        # S3 remote backend + locking (rename to use)
│   └── terraform.tfvars.example  # variable values template (copy to *.tfvars)
├── examples/                     # one runnable example per topic cluster
│   ├── 01-workflow/
│   ├── 02-hcl-syntax/
│   ├── 03-providers/
│   ├── 04-resources/
│   ├── 05-meta-arguments/
│   ├── 06-variables/
│   ├── 07-outputs-locals/
│   ├── 08-data-sources/
│   ├── 09-state-backend/
│   ├── 10-workspaces/
│   ├── 11-modules/               # root module + child module
│   ├── 12-provisioners/
│   ├── 13-functions-expressions/
│   └── 14-import-graph/
├── .github/workflows/
│   └── terraform-ci.yml          # fmt + validate + tflint on push/PR
└── docs/                         # placeholders for expanded per-topic notes
```

---

## Contents

| # | Topic | Section | Example |
|---|-------|---------|---------|
| 1 | Terraform workflow | [Jump](#1-terraform-workflow) | [`examples/01-workflow`](./examples/01-workflow) |
| 2 | HCL configuration syntax | [Jump](#2-terraform-configuration-syntax-hcl) | [`examples/02-hcl-syntax`](./examples/02-hcl-syntax) |
| 3 | Top-level block types | [Jump](#3-terraform-top-level-blocks) | - |
| 4 | Providers | [Jump](#4-providers) | [`examples/03-providers`](./examples/03-providers) |
| 5 | Dependency lock file | [Jump](#5-dependency-lock-file) | [`examples/03-providers`](./examples/03-providers) |
| 6 | Resources & behavior | [Jump](#6-resources--resource-behavior) | [`examples/04-resources`](./examples/04-resources) |
| 7 | Resource meta-arguments | [Jump](#7-resource-meta-arguments) | [`examples/05-meta-arguments`](./examples/05-meta-arguments) |
| 8 | Input variables | [Jump](#8-input-variables) | [`examples/06-variables`](./examples/06-variables) |
| 9 | Outputs & locals | [Jump](#9-output-values--local-values) | [`examples/07-outputs-locals`](./examples/07-outputs-locals) |
| 10 | Data sources | [Jump](#10-data-sources) | [`examples/08-data-sources`](./examples/08-data-sources) |
| 11 | State & backends | [Jump](#11-state--backends) | [`examples/09-state-backend`](./examples/09-state-backend) |
| 12 | State commands | [Jump](#12-inspecting--manipulating-state) | [`examples/09-state-backend`](./examples/09-state-backend) |
| 13 | Workspaces | [Jump](#13-workspaces) | [`examples/10-workspaces`](./examples/10-workspaces) |
| 14 | Modules | [Jump](#14-modules) | [`examples/11-modules`](./examples/11-modules) |
| 15 | Provisioners & connections | [Jump](#15-provisioners--connections) | [`examples/12-provisioners`](./examples/12-provisioners) |
| 16 | Functions & expressions | [Jump](#16-functions--expressions) | [`examples/13-functions-expressions`](./examples/13-functions-expressions) |
| 17 | Import & graph | [Jump](#17-import--graph) | [`examples/14-import-graph`](./examples/14-import-graph) |
| 18 | Debugging & logs | [Jump](#18-debugging--logs) | - |

---

## Prerequisites

```bash
terraform version           # install Terraform 1.6+ (https://developer.hashicorp.com/terraform/install)
aws configure               # or export AWS_ACCESS_KEY_ID / AWS_SECRET_ACCESS_KEY
```

Credentials are **never** stored in this repo. The provider and backend read
them from your environment or `~/.aws/credentials`. Most examples that create
real AWS resources are illustrative - run `terraform plan` freely (offline-ish),
and only `apply` in an account you control. Examples 01 (`random`) and the
`local-exec` parts of 12 run with no cloud account.

---

## 1. Terraform workflow

The everyday lifecycle is five commands. `init` prepares the working directory
and downloads providers; `validate` checks syntax and internal consistency;
`plan` refreshes and computes what actions reach the desired state; `apply`
executes them and updates state; `destroy` tears everything down.

```bash
terraform init       # initialize working dir, download providers, write lock file
terraform validate   # syntactically valid + internally consistent?
terraform plan       # execution plan: refresh state, diff to desired state
terraform apply      # apply changes; by default scans the current directory
terraform destroy    # destroy the Terraform-managed infrastructure
```

*Why it matters:* `init` is the first command you run on any new configuration,
and `plan` before `apply` is the habit that prevents surprise changes.

## 2. Terraform configuration syntax (HCL)

Terraform code is stored in plain-text `.tf` files written in **HCL** (HashiCorp
Configuration Language); there is also a JSON variant using the `.tf.json`
extension. Files containing Terraform code are called **configuration files**
(or a Terraform manifest). The basic building blocks are **blocks**,
**arguments**, **identifiers**, and **comments**.

```hcl
# Template of a block
<BLOCK_TYPE> "<block label>" "<block label>" {
  <IDENTIFIER> = <EXPRESSION>   # an argument
}

# AWS example: block type = resource; two labels = type + name
resource "aws_instance" "ec2_demo" {
  ami           = "ami-0abcdef1234567890"  # argument name = argument value
  instance_type = "t2.micro"
}
```

- **Arguments** configure a resource; some are **required**, some **optional**.
  Terraform errors and applies nothing if a required argument is missing.
- **Attributes** are values exposed by a resource, referenced in the form
  `<resource_type>.<resource_name>.<attribute_name>`.
- **Meta-arguments** are *not* resource-specific - they change a resource's
  behavior (e.g. `count`, `for_each`).
- **Block label count** depends on the block type: `variable` takes 1 label,
  `resource` takes 2.
- **Comments**: single line with `#` (default) or `//`; multi-line with `/* */`.

*Why it matters:* everything else in Terraform is just specific block types
following this one grammar.

## 3. Terraform top-level blocks

The language uses a limited number of **top-level block types** - blocks that
may appear at the top level of a configuration file. Most Terraform features are
implemented as one of these.

| Fundamental | Variable/output | Calling/referencing |
|-------------|-----------------|---------------------|
| `terraform` block | `variable` (input) block | `module` block |
| `provider` block | `output` block | |
| `resource` block | `locals` block | |
| | `data` (data source) block | |

*Why it matters:* recognizing the eight block types tells you, at a glance,
what any `.tf` file is doing.

## 4. Providers

A **provider** is the heart of Terraform. Every resource type (for example
`aws_instance`) is implemented by a provider - without one, Terraform can't
manage any infrastructure. Providers are distributed **separately** from
Terraform and each has its own release cycle and version numbers. The public
**Terraform Registry** hosts providers for most major platforms (AWS, Azure,
GCP, ...).

The registry offers two things - **providers** and **modules** - and classifies
publishers into tiers: **official** (owned/maintained by HashiCorp),
**partner/verified** (third-party technology partners whose authenticity
HashiCorp has verified), **community** (published by individual maintainers),
and **archived** (official or verified providers no longer maintained).

```hcl
terraform {
  required_version = ">= 1.6.0, < 2.0.0"

  required_providers {
    aws = {                       # local name
      source  = "hashicorp/aws"   # <HOSTNAME>/<NAMESPACE>/<TYPE>
      version = "~> 5.60"         # version constraint
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "default"   # reads local ~/.aws credentials (or use env vars)
}
```

- **Local names** are module-specific and must be unique per module. Terraform
  configuration always refers to a provider by its local name, which must match
  the `provider` block label. The recommended local name is the provider's
  preferred one (for the AWS provider that is `aws`).
- **Source** is the primary location Terraform downloads the provider from. The
  address has up to three parts delimited by slashes:
  `[<HOSTNAME>/]<NAMESPACE>/<TYPE>`. The hostname is optional and defaults to
  `registry.terraform.io`.

### Multiple providers (aliases)

You can define multiple configurations for the same provider and choose which
one to use per resource/module - primarily to support **multiple regions** of a
cloud platform. Select an alternate config with `<PROVIDER_NAME>.<ALIAS>`
(a special meta-argument in the resource).

```hcl
provider "aws" {                # default, us-east-1
  region  = "us-east-1"
  profile = "default"
}

provider "aws" {                # aliased, us-west-1
  region  = "us-west-1"
  profile = "default"
  alias   = "aws_west_1"
}

resource "aws_vpc" "vpc_us_west_1" {
  provider   = aws.aws_west_1   # <PROVIDER NAME>.<ALIAS>
  cidr_block = "10.2.0.0/16"
}
```

*Why it matters:* picking a provider version and knowing the source address is
what makes a configuration reproducible across machines.

## 5. Dependency lock file

`.terraform.lock.hcl` was introduced in Terraform 0.14. Terraform configuration
can depend on two kinds of external dependency: **providers** and **modules**.
Version *constraints* within the configuration decide which versions are
*potentially* compatible; after selecting a specific version of each provider,
Terraform records that decision in the **dependency lock file** so it can make
the same choice again by default in the future.

```bash
terraform init      # selects provider versions and writes .terraform.lock.hcl
terraform init -upgrade   # re-selects newest versions allowed by constraints
```

- The lock file lives in the current working directory and currently tracks
  **provider** dependencies (module version selections are not locked).
- It also stores **checksums**; on later runs Terraform verifies each installed
  provider package matches a recorded checksum, erroring if none match.
- With a lock file present, Terraform installs the **same** provider version for
  everyone across your team, so runs are consistent. If no lock file exists,
  Terraform downloads the newest version satisfying the constraint.

*Why it matters:* commit this file - it's how "works on my machine" becomes
"works on everyone's machine and in CI."

## 6. Resources & resource behavior

A `resource` block declares an infrastructure object. On each run Terraform
compares the **desired state** (all your `.tf` files - the local manifest) with
the **current state** (whatever exists in your cloud environment) and picks an
action per resource.

| Behavior | Meaning |
|----------|---------|
| **Create** | Resource exists in configuration but is not yet in state. |
| **Destroy** | Resource exists in state but no longer in configuration. |
| **Update in-place** | Arguments changed and can be patched on the live object. |
| **Destroy & re-create** | Arguments changed but cannot be updated in-place (e.g. a remote-API limitation); shown in the plan as `-/+`. |

```hcl
resource "aws_instance" "web" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "t2.micro"      # change this to trigger update or replacement
  tags          = { Name = "web-server" }
}
```

```bash
terraform fmt      # rewrite files into the canonical Terraform format
```

*Why it matters:* reading a plan is really just reading these four verbs.

## 7. Resource meta-arguments

Meta-arguments can be used with **any** resource type to change its behavior:
`depends_on`, `count`, `for_each`, `provider`, and `lifecycle`.

**`depends_on`** - handle hidden resource/module dependencies Terraform can't
infer automatically. Needed only when a resource relies on another's behavior
without referencing its data. Value must be a list of references; add a comment
explaining why.

```hcl
resource "aws_eip" "web" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.gw]  # EIP needs the IGW to exist first
}
```

**`count`** - create N instances. Each instance has a distinct index
(`count.index`, starting at 0) and its own infrastructure object.

```hcl
resource "aws_instance" "web" {
  count         = 3
  ami           = "ami-0abcdef1234567890"
  instance_type = "t2.micro"
  tags          = { Name = "web-${count.index}" }  # web-0, web-1, web-2
}
```

**`for_each`** - create one instance per member of a **map** or **set of
strings**. Inside the block, `each.key` and `each.value` are available.

```hcl
# set of strings: each.key == each.value
resource "aws_iam_user" "team" {
  for_each = toset(["jack", "james"])
  name     = each.key
}

# map: each.key = key, each.value = value
resource "aws_s3_bucket" "envs" {
  for_each = { dev = "my-app-dev-bucket" }
  bucket   = each.value
  tags     = { Env = each.key }
}
```

**`lifecycle`** - alter standard resource behavior:

```hcl
lifecycle {
  create_before_destroy = true          # create the new resource before destroying the old
  prevent_destroy       = true          # guard costly objects (e.g. a database) from deletion
  ignore_changes        = [tags]        # ignore drift Terraform would otherwise revert
}
```

> A given resource or module block **cannot** use both `count` and `for_each`.

*Why it matters:* `count`/`for_each` remove copy-paste, and `lifecycle` is your
safety net for stateful, expensive resources.

## 8. Input variables

Input variables serve as **parameters** for a Terraform module, letting you
customize behavior without editing the module's source and letting modules be
shared between configurations. Ways to set them (see precedence below):

```hcl
variable "ec2_count" {
  description = "EC2 instance count"
  type        = number
  default     = 1              # if omitted, Terraform prompts for the value
}
```

```bash
# override the default with a CLI argument
terraform plan -var="ec2_type=t3.large" -var="ec2_count=1"

# generate a plan file with -var, then apply that exact plan
terraform plan -var="ec2_type=t3.large" -var="ec2_count=1" -out v3out.plan
terraform apply v3out.plan

# environment variable override (prefix TF_VAR_)
export TF_VAR_ec2_count=3

# auto-loaded file: terraform.tfvars (also *.auto.tfvars)
# custom file needs -var-file:
terraform plan  -var-file="web.tfvars"
terraform apply -var-file="app.tfvars"
```

### Complex types

```hcl
variable "ec2_instance_types" {
  type    = list(string)
  default = ["t2.micro", "t2.small", "t2.large"]
}

# reference: var.ec2_instance_types[0] -> "t2.micro"
```

- **list / tuple**: an ordered sequence of values; elements identified by
  consecutive whole numbers starting at zero.
- **map / object**: a group of values identified by named labels, e.g.
  `{ name = "mabli", age = 52 }`.

### Validation, console, and helper functions

```hcl
variable "ec2_ami_id" {
  type = string
  validation {
    condition     = length(var.ec2_ami_id) > 4 && substr(var.ec2_ami_id, 0, 4) == "ami-"
    error_message = "The value must start with \"ami-\"."
  }
}
```

Explore expressions interactively with `terraform console`:

```hcl
length("hello")                 # 5   (length of a string)
length(["a", "b", "c"])         # 3   (list)
length({ key = "value" })       # 1   (map)
substr("hello world", 1, 4)     # "ello"  (offset 1, length 4)
```

### Protecting sensitive input variables

```hcl
variable "db_password" {
  type      = string
  sensitive = true    # Terraform redacts this in CLI/plan output
}
```

```bash
export TF_VAR_db_password="s3cr3t"   # keep secrets out of files/CLI history
```

- Never check `secret.tfvars` into Git.
- The Terraform **state file** (`terraform.tfstate`) contains values for
  sensitive variables - keep state secure to avoid exposing data.

### Variable definition precedence

The same variable can be set in several places; Terraform uses the **last**
value it finds, overriding earlier ones. It loads variables in this order:

1. Environment variables (`TF_VAR_...`)
2. `terraform.tfvars`
3. `terraform.tfvars.json`
4. `*.auto.tfvars` / `*.auto.tfvars.json`
5. `-var` and `-var-file` options on the command line

*Why it matters:* precedence is the #1 source of "why did it use *that* value?"
confusion - memorize the order.

## 9. Output values & local values

**Output values** are like a module's return values and have several uses:
a root module can print them to the CLI after `apply`; a child module can expose
a subset of its resource attributes to a parent module; and with remote state,
a root module's outputs can be read by other configurations via the
`terraform_remote_state` data source.

```hcl
output "ec2_instance_public_ip" {
  description = "EC2 instance Public IP"
  value       = aws_instance.my_ec2_vm.public_ip
}

# Suppress a sensitive value from plan/apply CLI output:
output "db_endpoint" {
  value     = aws_db_instance.main.endpoint
  sensitive = true
}
```

- `sensitive = true` only redacts the **CLI** output for `plan`/`apply`. Querying
  with `terraform output` can still show the value, and it remains in state.
- Generate machine-readable output with `terraform output -json`.

**Local values** follow the **DRY** principle (Don't Repeat Yourself) and reduce
code complexity: a local assigns a name to an expression so you can use that name
multiple times within a module without repeating it. Reference one as
`local.<name>`. The ability to change a value in one central place is the key
advantage; overusing them can make configuration harder to read.

```hcl
locals {
  service_name = "forum"
  owner        = "Community Team"

  common_tags = {
    Service = local.service_name
    Owner   = local.owner
  }
}

resource "aws_instance" "example" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "t2.micro"
  tags          = local.common_tags
}
```

*Why it matters:* outputs wire modules together; locals keep repeated values in
one place.

## 10. Data sources

Data sources allow data to be **fetched or computed** for use elsewhere in a
Terraform configuration - information defined outside Terraform, or defined by
another separate configuration. A data source is accessed via a special kind of
resource (a **data resource**) declared with a `data` block, and referenced as
`data.<type>.<name>.<attribute>`.

```hcl
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.amazon_linux.id   # get AMI id for creating the instance
  instance_type = "t2.micro"
}
```

- Each data resource is associated with a single data source, which determines
  what it reads and which query constraint arguments are available.
- Data resources share the same dependency-resolution behavior as managed
  resources (setting `depends_on` inside a `data` block defers the read until
  after dependencies settle).
- Data resources support the `provider` meta-argument and `count` / `for_each`,
  but currently have no `lifecycle` customization.

*Why it matters:* stop hardcoding AMI IDs, VPC IDs, and account numbers - look
them up.

## 11. State & backends

Terraform must store **state** about your managed infrastructure and
configuration. State maps real-world resources to your configuration
(`.tf` files), keeps track of metadata, and improves performance for large
infrastructures. By default state is stored locally in `terraform.tfstate`, but
it can be stored remotely, which works better in a team environment. In the
state file you can identify a resource by its **local name** (local names
matter). The primary purpose of state is to store bindings between remote
objects and the resource instances declared in your configuration.

### Local vs remote state

- **Local state file:** multiple team members can't update infra because they
  don't share the state file - which is exactly why you move it to shared
  storage.
- **Remote state file:** using Terraform's **backend** concept you can use, for
  example, AWS S3 as shared storage. If two people run Terraform at the same
  time without protection, concurrent writes can corrupt state - hence locking.

### Terraform backends

A **backend** stores state and, for some types, performs operations. Terraform
uses persistent state data to track the resources it manages. Everyone working
with a given collection of infrastructure resources must be able to access the
same state data (shared state storage).

- **State locking** prevents conflicts and inconsistencies while operations are
  being performed. When an admin changes infrastructure, Terraform locks the
  state, performs the change, then releases the lock - so concurrent runs can't
  clobber each other.
- Not all backends support locking; **AWS S3 does**. Locking happens
  automatically on operations that could write state (any `terraform` command
  that writes state).
- You can disable locking on most commands with the `-lock` flag, but it's not
  recommended.
- **Operations** refers to performing API requests against infrastructure to
  create/read/update/destroy resources. Not every subcommand performs API
  operations - many only operate on state data. Only two backends actually
  perform operations: **local** and **remote**.
- If acquiring the lock takes longer than expected, Terraform prints a status
  message; if it doesn't, locking may still be in progress if your backend
  supports it. Terraform has a **`force-unlock`** command to manually release a
  stuck lock (use as a last resort).

```hcl
terraform {
  backend "s3" {
    bucket       = "my-org-terraform-state"
    key          = "study/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true      # native S3 locking (Terraform >= 1.10)
    # dynamodb_table = "terraform-locks"   # older locking mechanism
  }
}
```

*Why it matters:* remote state + locking is the difference between a solo toy
and a team-safe pipeline.

## 12. Inspecting & manipulating state

```bash
# --- inspecting state ------------------------------------------------------
terraform refresh                       # detect drift from real infra; update
                                        #   state only (NOT infrastructure).
                                        #   Order under the hood: refresh, plan,
                                        #   decision, apply.
terraform state list                    # list resources within the state
terraform state show aws_instance.my_ec2_vm   # show a single resource's attrs

# --- moving / removing (advanced, careful) --------------------------------
terraform state mv SOURCE DEST          # move/rename an item to a destination
                                        #   address (can target a different
                                        #   state file). VERY dangerous - test
                                        #   in lower environments first. After a
                                        #   mv you must also rename the matching
                                        #   block in your configuration, then run
                                        #   plan/apply (which should show no infra
                                        #   change - only the state moved).
terraform state mv -dry-run SOURCE DEST # preview the move
terraform state rm aws_instance.my_ec2_vm     # forget a resource (leaves infra).
                                        #   Back up state first (state pull).

# --- disaster recovery: pull / push ---------------------------------------
terraform state pull > backup.tfstate   # download & output remote (or local)
                                        #   state as raw JSON to stdout
terraform state push terraform.tfstate  # upload a local state file to remote

# --- providers / locks -----------------------------------------------------
terraform state replace-provider OLD NEW
terraform force-unlock LOCK_ID          # manually unlock the state for the
                                        #   current config; does NOT modify infra

# --- forcing recreation ----------------------------------------------------
terraform taint aws_instance.my_ec2_vm    # mark a managed resource as tainted so
                                        #   it is destroyed & recreated next apply
terraform untaint aws_instance.my_ec2_vm  # unmark (restore as the primary instance)

# --- targeting & destroy ---------------------------------------------------
terraform plan  -target=aws_instance.my_ec2_vm   # focus on a subset of resources
terraform apply -target=aws_instance.my_ec2_vm   # (not recommended for routine use;
                                                 #  can cause config drift/confusion)
terraform destroy -auto-approve                  # tear everything down
rm -rf .terraform* vplan.out                     # clean-up local files
```

*Why it matters:* these are your emergency tools - powerful, occasionally
destructive, always worth a state backup first.

## 13. Workspaces

A **workspace** is an environment that lets you manage multiple instances of the
**same** infrastructure configuration within a single Terraform project. Each
workspace has its **own state file**, so changes made in one workspace don't
affect others - letting you share Terraform configuration across environments
while managing separate infrastructure state.

Every Terraform project starts with a default workspace named **`default`**,
which holds the initial state and is the only workspace until you create more.

```bash
terraform workspace new Dev            # create a new workspace
terraform workspace list               # list workspaces (current is marked *)
terraform workspace select Production  # switch workspaces
terraform workspace delete Dev         # delete (you can't delete the ACTIVE one)
```

```hcl
resource "aws_instance" "example" {
  ami           = "ami-0abcdef1234567890"
  instance_type = terraform.workspace == "Production" ? "t3.large" : "t3.micro"
  tags          = { Name = "my-instance-${terraform.workspace}" }
}
```

*Why it matters:* one config, many environments - as long as you remember each
workspace is a separate state.

## 14. Modules

A **module** is a container for multiple resources used together. The **root
module** is the working directory where you run `terraform`; it can call
**child modules** with a `module` block, passing input variables and consuming
their outputs. Modules make configuration reusable and shareable.

```hcl
# root module calling a local child module
module "web" {
  source = "./modules/ec2-instance"   # local path, registry, or Git URL

  name          = "web-server"
  ami_id        = "ami-0abcdef1234567890"
  instance_type = "t3.micro"
}

# consume a child module output
output "web_instance_id" {
  value = module.web.instance_id
}
```

- **Sources:** local path (`./modules/...`), Terraform Registry
  (`namespace/name/provider`, pinned with `version`), or a Git/HTTP URL.
- **Inputs/outputs:** pass values to the module's `variable`s; read results as
  `module.<name>.<output>`.
- `count` and `for_each` work on `module` blocks (support added in Terraform
  0.13).

*Why it matters:* modules are how Terraform scales from one file to a platform.

## 15. Provisioners & connections

Provisioners take **extra action after resource creation** - for example,
installing an app on a server, or doing something on the local machine after a
resource is created at a remote destination. Treat them as a last resort.

```hcl
resource "aws_instance" "web" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "t2.micro"
  key_name      = "my-keypair"

  provisioner "local-exec" {                 # run a command where Terraform runs
    command = "echo ${self.public_ip} >> ips.txt"
  }

  connection {                               # how to reach the instance
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file("~/.ssh/id_rsa")
  }

  provisioner "file" {                       # copy a file to the remote host
    source      = "app.conf"
    destination = "/tmp/app.conf"
  }

  provisioner "remote-exec" {                # run commands ON the instance
    inline = ["sudo yum install -y nginx", "sudo systemctl enable --now nginx"]
  }

  provisioner "local-exec" {                 # destroy-time provisioner
    when    = destroy
    command = "echo 'destroyed' >> lifecycle.log"
  }
}

resource "null_resource" "post_deploy" {     # provisioners without a real resource
  triggers = { instance_id = aws_instance.web.id }
  provisioner "local-exec" {
    command = "echo 'deployed ${aws_instance.web.id}'"
  }
}
```

*Why it matters:* sometimes you must reach into a machine - but prefer
`user_data`/cloud-init and native resources first.

## 16. Functions & expressions

Terraform functions are predefined operations that help you manipulate and
process data within a configuration. Terraform does **not** support user-defined
functions - only the built-ins, grouped into categories such as **string**,
**numeric**, **collection**, and **type-conversion** functions.

```hcl
# String functions
concat("Hello", "world")            # note: concat is for LISTS; use join/format for strings
join(",", ["a", "b", "c"])          # "a,b,c"
split(",", "apple,banana,cherry")   # ["apple", "banana", "cherry"]

# Collection functions
length([1, 2, 3])                   # 3
element(["apple", "banana", "cherry"], 1)   # "banana"
merge({ a = 1, b = 2 }, { c = 3 })  # { a = 1, b = 2, c = 3 }
slice([1, 2, 3, 4], 1, 3)           # [2, 3]

# Filesystem function
file("${path.module}/greeting.txt") # file contents as a string
```

Expression features:

```hcl
# conditional (ternary)
instance_type = var.environment == "prod" ? "t3.large" : "t3.micro"

# for expression (transform)
upper_azs = [for az in var.azs : upper(az)]

# dynamic block (generate repeated nested blocks)
dynamic "ingress" {
  for_each = { http = 80, https = 443 }
  content {
    from_port   = ingress.value
    to_port     = ingress.value
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```

Use `terraform console` to evaluate any of these interactively.

*Why it matters:* functions and expressions turn static config into flexible,
data-driven infrastructure.

## 17. Import & graph

**`terraform import`** brings existing infrastructure under Terraform management
by importing its state into your configuration - useful when resources were
created manually or by another tool. It updates **only the state file**; it does
**not** modify your `.tf` files, so you must write a matching resource block
yourself and then reconcile.

```bash
# 1) write a resource block that matches the real object
# 2) import the real object's ID into state:
terraform import aws_instance.my_instance i-0abc123def456
# 3) verify - the config may still be incomplete:
terraform plan
```

**`terraform graph`** generates a visual representation of the resource
dependencies in your configuration, output in **DOT** format. Use Graphviz to
convert it into a visual graph (PNG, SVG, PDF). It helps you understand
relationships/dependencies, debug ordering, and ensure proper dependency
management.

```bash
terraform graph > graph.dot
dot -Tpng graph.dot -o graph.png
```

*Why it matters:* `import` adopts brownfield infra; `graph` explains why
Terraform ordered things the way it did.

## 18. Debugging & logs

Terraform's **debug mode** gives detailed logs about the execution process to
diagnose issues and unexpected behavior. Enable it with the `TF_LOG` environment
variable, and optionally capture output to a file with `TF_LOG_PATH`.

- **`TF_LOG`** controls verbosity. Log levels from most to least verbose:
  **TRACE** (logs every internal operation - overwhelming but useful for
  in-depth debugging), **DEBUG** (detailed info about Terraform actions;
  generally right for most debugging), **INFO** (informational messages about
  the workflow), **WARN** (warnings that may indicate potential issues),
  **ERROR** (only error messages).
- **`TF_LOG_PATH`** specifies a file path to save log output.

```bash
cd $HOME
# in ~/.bashrc (or just export in the shell):
export TF_LOG=TRACE
export TF_LOG_PATH="terraform-trace.log"

# verify:
echo $TF_LOG          # TRACE
echo $TF_LOG_PATH     # terraform-trace.log
```

**Crash logs:** when Terraform hits an unexpected error/failure during execution
(often provider-plugin, memory, resource, or internal issues) it can crash and
write a `crash.log` in the current directory containing detailed information.
Generally that file is meant to be passed along to the developers via a GitHub
issue - as a user you're not required to dig into it.

*Why it matters:* when a run misbehaves, `TF_LOG=DEBUG` is usually the fastest
path to the real cause.

---
## Practical labs

Self-contained, hands-on exercises. Each assumes Terraform 1.6+ installed. Labs
1 and 8 need **no** cloud account; the rest use AWS (run `plan` freely, `apply`
only in an account you control - and `destroy` when done).

1. **Walk the workflow (no cloud).** In `examples/01-workflow`, run
   `init -> validate -> plan -> apply -> destroy`. Inspect the generated
   `terraform.tfstate` and `.terraform.lock.hcl`. Delete `.terraform` and re-run
   `init`; note the lock file keeps the provider version stable.

2. **Read a plan's four verbs.** In `examples/04-resources`, `apply`, then change
   `instance_type`, then `plan`. Identify whether it's an *update in-place* or a
   *destroy & re-create* (`-/+`). Add a `tags` change and re-read the plan.

3. **Count vs for_each.** In `examples/05-meta-arguments`, convert the `count`
   web servers to a `for_each` over `toset(["a","b","c"])`. Observe how the
   resource addresses change from `[0]`/`[1]` to `["a"]`/`["b"]`.

4. **Variable precedence duel.** In `examples/06-variables`, set `ec2_count` via
   a `default`, a `terraform.tfvars`, a `TF_VAR_ec2_count` env var, and a `-var`
   flag simultaneously. Predict, then confirm, which value wins.

5. **Guard a resource.** Add `lifecycle { prevent_destroy = true }` to a resource
   and try `terraform destroy`. Watch it refuse, then remove the guard.

6. **Look it up, don't hardcode.** In `examples/08-data-sources`, replace the
   hardcoded AMI in another example with the `data.aws_ami.amazon_linux.id`
   lookup. Run `terraform console` and evaluate `data.aws_ami.amazon_linux.id`.

7. **Go remote.** Using `config/backend.tf.example`, create an S3 bucket, wire up
   the backend, and `terraform init` to migrate local state to S3. Run
   `terraform state list` against the remote state.

8. **Console gym (no cloud).** Run `terraform console` and evaluate:
   `length(["a","b","c"])`, `substr("hello world", 1, 4)`,
   `merge({a=1},{b=2})`, `[for x in ["a","b"] : upper(x)]`.

9. **Module-ize it.** In `examples/11-modules`, add a second `module "api"` block
   reusing `./modules/ec2-instance` with different inputs, then output both
   instance IDs.

10. **Adopt & visualize.** Create an EC2 instance by hand (or pretend), write a
    matching block, `terraform import` it (Lab-safe: read `examples/14-import-graph`),
    then run `terraform graph > graph.dot && dot -Tpng graph.dot -o graph.png`.

11. **Debug a run.** `export TF_LOG=DEBUG` and `TF_LOG_PATH=tf.log`, run a `plan`,
    then open `tf.log` and find where the provider is initialized.

12. **Taint drill.** `terraform taint` a resource, read the resulting `-/+` plan,
    then `terraform untaint` to cancel it before applying.

---

## Topic coverage index

Everything included, for a scannable coverage check:

- [x] Terraform intro: creates **and maintains** resources; records real-world
      cloud resources in the **state file**
- [x] Workflow: `init`, `validate`, `plan`, `apply`, `destroy`
- [x] Configuration syntax (HCL): `.tf` / `.tf.json`, configuration files /
      manifest
- [x] Blocks, arguments, identifiers, attributes, meta-arguments; block labels
- [x] Comments: `#`, `//`, `/* */`
- [x] Required vs optional arguments; attribute references; meta-arguments
- [x] Top-level block types: `terraform`, `provider`, `resource`, `variable`,
      `output`, `locals`, `data`, `module`
- [x] Providers: introduction (heart of Terraform), configuration, requirements
- [x] Provider source address `[<HOSTNAME>/]<NAMESPACE>/<TYPE>`; local names;
      preferred local name
- [x] Terraform Registry: providers & modules; tiers (official, partner/verified,
      community, archived)
- [x] Multiple providers & aliases (`<PROVIDER>.<ALIAS>`)
- [x] Dependency lock file (`.terraform.lock.hcl`): constraints, checksums,
      importance
- [x] Resources & behavior: create, destroy, update-in-place,
      destroy-and-recreate; `terraform fmt`
- [x] Resource meta-arguments: `depends_on`, `count` (`count.index`), `for_each`
      (`each.key`/`each.value`, `toset`), `provider`, `lifecycle`
- [x] Lifecycle: `create_before_destroy`, `prevent_destroy`, `ignore_changes`
- [x] `count` vs `for_each` (cannot use both)
- [x] Provisioners & connection: `local-exec`, `remote-exec`, `file`,
      `null_resource`, destroy-time
- [x] Input variables: assignment (default, prompt, `-var`, `TF_VAR_`,
      `terraform.tfvars`, `*.auto.tfvars`, `-var-file`)
- [x] Complex types: `list`/`tuple`, `map`/`object`
- [x] `length`, `substr`, `file` functions; `terraform console`
- [x] Custom validation; sensitive input variables; variable definition
      precedence
- [x] Output values: root/child uses, remote-state consumption; `sensitive`;
      `-json`
- [x] Local values (DRY)
- [x] Data sources (`data` block; `data.<type>.<name>.<attr>`)
- [x] State: purpose, local vs remote, desired vs current state
- [x] Backends: store state, state locking, operations (local/remote)
- [x] State locking, disabling locks, `force-unlock`
- [x] State commands: `refresh`, `state list`, `state show`, `state mv` (+`-dry-run`),
      `state rm`, `state pull`, `state push`, `state replace-provider`
- [x] `taint` / `untaint`; `-target`; `destroy`; clean-up
- [x] Workspaces: `default`, separate state files; `new`/`list`/`select`/`delete`;
      `terraform.workspace`
- [x] Modules: root vs child, sources, versions, inputs/outputs, `count`/`for_each`
- [x] Functions & expressions: string/numeric/collection; conditional, `for`,
      `dynamic` blocks
- [x] `terraform import`
- [x] `terraform graph` (DOT -> Graphviz)
- [x] Debugging: `TF_LOG` levels (TRACE/DEBUG/INFO/WARN/ERROR), `TF_LOG_PATH`,
      crash logs

---

## Scope & honesty note

- **"Complete" means complete across standard, current Terraform** (CLI 1.6+,
  AWS provider ~> 5.x). The examples are runnable and syntax-checked, but they
  aren't a substitute for the official docs at
  `developer.hashicorp.com/terraform`.
- This repo was built to mirror a specific handwritten Terraform notes set. The
  core-curriculum sections (workflow, HCL syntax, providers, lock file,
  resources, meta-arguments, variables, outputs/locals, data sources, state &
  backends, state commands, workspaces, import, graph) map directly to those
  notes. The later sections (**modules**, **provisioners**, **functions &
  expressions**, **debugging/logs**) round out the standard curriculum that the
  notes continue into; treat those as standard-Terraform completions rather than
  verbatim transcriptions.
- **Environment-dependent bits you must supply:** AWS credentials/region, real
  AMI IDs (the examples use placeholder `ami-0abcdef1234567890`), an S3 bucket +
  (optional) DynamoDB table for the remote backend, and an SSH key pair for the
  provisioner example. These depend on *your* account and are intentionally not
  bundled.
- **Validation done here:** every `.tf`/`.example` file is parsed as HCL and the
  CI YAML is checked. Full `terraform init/validate/fmt` and `tflint` run in CI
  (and locally) - the HashiCorp release host isn't reachable from this build
  environment, so run them once in yours to get the green CI badge.

---

## Publishing

See the git commands at the bottom of this file (or in your terminal history).
Before pushing, edit the placeholders listed in **Placeholders to edit**.

## License

[MIT](./LICENSE)
