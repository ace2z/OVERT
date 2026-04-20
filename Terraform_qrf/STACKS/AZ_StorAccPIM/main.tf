
//data "azurerm_client_config" "current" {}

locals {
  mainRG = "rg-terryScratchBox"  
}

// ▮▮▮ 
// ▮▮▮ Deploy test storage acc
module "storACC" {
  count = var.env_name == "dev" ? 1 : 0  
  source = "https://github.com/ace2z/OVERT.git//Terraform_qrf/TFMOD_commun/azure/azStorAcc?ref=main"
  Name    = "terryteststor"
  RG_Name = local.mainRG  
  CreateContainer = true

  tags = local.project_tags
  
  providers = {
    azurerm.prvdr_SUB = azurerm.prvdr_TerryDEVSub
  }
}

// ▮▮▮ Deploy the PIM IAM elevation 
module "pim_elev" {
  count  = var.env_name == "dev" ? 1 : 0
  source = "https://github.com/ace2z/OVERT.git//Terraform_qrf/TFMOD_commun/azure/PIM_elevation?ref=main"

  TARGET_resource_id = module.storACC[0].id // Scope of the eligible role assignment, in this case the storage account

  tags = local.project_tags

  providers = {
    azurerm.prvdr_SUB = azurerm.prvdr_TerryDEVSub
  }

  depends_on = [module.storACC] 
}



