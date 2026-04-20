locals {

  namePREF = "ace_IAM_Role_"
  nameSUFF = module.meta.rand_id

  tmpname = "${local.namePREF}Keyvault Admin"

  subid = "XXXX-XXXXXXX-XXXX-XXXXX-XXXX"

  SCOPE_subscription = "/subscriptions/${local.subid}"

  TARGET_principal_id = "XXXX-XXXXXXX-XXXX-XXXXX-XXXX" // Object ID of user/group/SP
  SCOPE_resid         = "/subscriptions/XXXX-XXXXXXX-XXXX-XXXXX-XXXX/resourceGroups/rg-TerryTestCaseRG"

  EXP_AFTER = "PT8H" // ISO 8601 duration format, example: P8H for 8 hours, P1D for 1 day

  revised_roledef_ID = "/subscriptions/${local.subid}${data.azurerm_role_definition.IAMstoblobDataContrib.id}"
  
  group_id = "XXXX-XXXXXXX-XXXX-XXXXX-XXXX" 

  //maxDurationHours = "8h"
  maxDurationHours = "1h"
}

//data "azurerm_client_config" "current" {}
data "azurerm_subscription" "mainsub" {
  subscription_id = local.subid
}

data "azurerm_role_definition" "iam_contrib" {
  name = "Contributor"
}

data "azurerm_role_definition" "IAMstoblobDataContrib" {
  name = "Storage Blob Data Contributor"
}


data "azurerm_role_definition" "IAMTEST" {
  name  = "Storage Blob Data Contributor"
  scope = data.azurerm_subscription.mainsub.id
}

data "azurerm_role_definition" "IAM2nd" {
  name  = "Storage Blob Data Contributor"
  scope = data.azurerm_subscription.mainsub.id
}


// ▮▮▮ This makes a user/group "eligble" for role assignment 

resource "azurerm_pim_eligible_role_assignment" "TF_elig_assign" {
  principal_id       = local.group_id           // anyone in this GROUP...
  scope              = local.SCOPE_subscription // ...can activate the below role_definition_id for themselves in THIS SCOPE context (ie subscription)
  role_definition_id = "${data.azurerm_subscription.mainsub.id}${data.azurerm_role_definition.IAMstoblobDataContrib.id}"
  
  
  schedule {
    start_date_time = timeadd(timestamp(), "0m") // Starts now
    expiration {
      end_date_time = timeadd(timestamp(), "${local.maxDurationHours}")
    }
  }

}

