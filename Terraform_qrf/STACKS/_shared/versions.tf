/*
 Core version and providers
*/

terraform {
  required_version = ">= 1.8.1" // terraform CLI command must be >= to this version
  backend "azurerm" {
    tenant_id = "ZZZZZZ-ZZZZ-ZZZZ-ZZZZ-ZZZZZZZZZZ"
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.68.0"
    }

    // ▮▮▮ Most Common used supplemental providers
    time = {
      source  = "hashicorp/time"
      version = "0.12.1" // last 'stable' version JUST before NEXT 'major/minor' release (was "0.11.1")
    }
    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }

/* 
  ▮▮▮ 
  ▮▮▮ MISC - (as needed)

    /*    
    aws = {
      source  = "hashicorp/terraform-provider-aws"
      version = "6.36.0"
    }
    awscc = { // needed for certain specific AWS provisioning (like WAF)
      source  = "hashicorp/awscc"
      version = "1.72.0"
    }
    local = { // for adhoc running local commands if needed
      source  = "hashicorp/local"
      version = "2.6.2" 
    }
    azuread = { // for interacting with Azure AD (users/groups/roles) if needed
      source  = "hashicorp/azuread"
      version = "3.7.0"
    }
    null = { // for null resources (this is legacy/not needed much anymore, see terraform_data instead)
      source  = "hashicorp/null"
      version = "3.2.3"
    }    
    external = { // hack/'escape hatch' provider for interacting with external programs via JSON. Rarely used
      source  = "hashicorp/external"
      version = "2.3.4" 
    }
  */

  }
}
/*
  ▮▮▮
  ▮▮▮ Provider Specific Configurations (dont modify)  
*/
provider "azurerm" {
  # Configuration options
  features {
    key_vault {
      /*
      NOTE: using 'purge_soft_delete_on_destroy=true' and 'recover_soft_deleted_key_vaults=true' 
      will make terraform FIRST check for an existing KV of the same name, and try to RECOVER it
      */
      recover_soft_deleted_key_vaults = false //true
      recover_soft_deleted_secrets    = false //true
      recover_soft_deleted_keys       = false //true      

      purge_soft_delete_on_destroy       = true // This prevents name collisions / 'conflict 409 error', when reusing same KV name after destroy,
      purge_soft_deleted_keys_on_destroy = true 
      
    }
    resource_group {
      prevent_deletion_if_contains_resources = true
    }
    template_deployment {
      delete_nested_items_during_deletion = true
    }
    virtual_machine {
      delete_os_disk_on_deletion = true
      //'graceful_shutdown' has been deprecated and will be removed from v5.0 of the AzureRM provider.
      skip_shutdown_and_force_delete = false
    }
  }

  // Backend state config 
  tenant_id       = "ZZZZZZ-ZZZZ-ZZZZ-ZZZZ-ZZZZZZZZZZ"
  client_id       = var.client_id
  client_secret   = var.client_secret
  subscription_id = var.subscription_id
}

