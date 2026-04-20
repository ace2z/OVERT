# Terraform Module - Azure PIM (iam privilege elevation)
### [ DRAFT ]

### Summary
This module implements Azure PIM (Privileged Identity Management) Elevated Priveleges. Elevated privileges are limited by time. (8 hours by default)

### Usage:
* **Invocation from main.tf / {TFROOT}** 
```text
module "azpim" {
  source = "https://github.com/ace2z/OVERT.git//Terraform_qrf/TFMOD_commun/azure/PIM_elevation?ref=main"

  TARGET_scope_id = "/subscriptions/XXXXX/resourceGroups/YYYYY/providers/Microsoft.Storage/storageAccounts/stZZZZZZ"
  TARGET_groupAllowed = "XXXX-XXXXXXX-XXXX-XXXXX-XXXX"
}
```

### Outputs if needed:
TBD - 
TBD - 
