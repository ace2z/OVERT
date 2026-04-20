/*
▮▮▮ Module Main - Code all APP STACK specific logic within modules like this
*/

/* ▮▮▮ These are the Object ID's for the SP and User(s) that need access to all resources
    Mode Reference:
      "Indexed"  # Applies to resources that support tags and location
      https://learn.microsoft.com/en-us/azure/governance/policy/concepts/definition-structure-basics#resource-provider-modes
      https://oneuptime.com/blog/post/2026-02-16-how-to-implement-azure-policy-as-code-using-terraform-azurerm-policy-definition/view
*/

locals {
  polPREFIX = "ace"
  mgm_groupID = "/providers/Microsoft.Management/managementGroups/${var.MGMT_GRP_NAME}"
}

// ▮▮▮ 1. Define the Policy | "effect": "deny" | "modify"
resource "azurerm_policy_definition" "TF_azp_KV" {
  name                = "${local.polPREFIX}-AZP-kv_no_public_access"
  display_name        = "${local.polPREFIX}-AZP-kv_no_public_access"
  policy_type         = "Custom"  // BuiltIn | Custom | NotSpecified 
  mode                = "Indexed" // All == all resources even those that dont support tagging
  management_group_id = local.mgm_groupID
  metadata            = <<METADATA
    {
      "ace_PolicyCategory": "General_MISC"
    }
METADATA

  policy_rule = <<POLICY_RULE
    {
      "if": {
          "field": "Microsoft.KeyVault/vaults/publicNetworkAccess",
          "notEquals": "false"
      },
    
      "then": {
        "effect": "modify",
        "details": {
          "roleDefinitionIds": ["/subscriptions/XXXX-XXXXXXX-XXXX-XXXXX-XXXX/providers/Microsoft.Authorization/roleDefinitions/XXXX-XXXXXXX-XXXX-XXXXX-XXXX"],
          "operations": [
            {
              "operation": "addOrReplace",
              "field": "Microsoft.KeyVault/vaults/publicNetworkAccess",
              "value": "false"
            }
          ]
        }        
      }
    }
POLICY_RULE

}



/*
 ▮▮▮ 
 ▮▮▮ 2. Assign the Policy to the Management Group
 NOTE: The policy assignment name length must NOT exceed '24' characters.
 ace_Policy: Key Vault N
 ace:KV_NoPublicAccess
*/
resource "azurerm_management_group_policy_assignment" "TF_mgmgrp_assign" {
  name                 = "${local.polPREFIX} KV_NoPub_Access"
  description          = "${local.polPREFIX} Disable Public Access for Azure Keyvaults"
  management_group_id  = local.mgm_groupID
  policy_definition_id = azurerm_policy_definition.TF_azp_KV.id
}

resource "azurerm_resource_group_policy_remediation" "TF_azp_remedKV" {
  name                 = "remediate-keyvault-rg"
  resource_group_id    = var.AZP_RGHolder_id
  policy_assignment_id = azurerm_management_group_policy_assignment.TF_mgmgrp_assign.id

  # Optional settings
  resource_discovery_mode = "ExistingNonCompliant"
}



// ▮▮▮ 
// ▮▮▮ OUTPUTS (must be unique across all other policy/ TF files )
output "policy_KV_id" {
  value = azurerm_policy_definition.TF_azp_KV.id
}
output "policy_KV_ROLE_DEF_IDs" {
  value = azurerm_policy_definition.TF_azp_KV.role_definition_ids
}

