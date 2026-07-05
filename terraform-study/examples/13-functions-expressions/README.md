# 13 - Functions & expressions

Terraform ships many built-in functions. Try them in `terraform console`:

```hcl
length("hello")                 # 5
length(["a", "b", "c"])         # 3
length({ key = "value" })       # 1
substr("hello world", 1, 4)     # "ello"
file("${path.module}/greeting.txt")   # file contents as a string
```

Expression features shown in `main.tf`:

- **Conditional** (`cond ? a : b`) for environment-based choices.
- **`for` expressions** to transform lists/maps.
- **`dynamic` blocks** to generate repeated nested blocks (ingress rules).
- Helpers like **`cidrsubnet`**, **`upper`**, **`merge`**, **`toset`**.
