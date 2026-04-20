/* 
 Additional "ALIAS" AzureRM providers for accessing different subscriptions
*/
provider "azurerm" {
  alias = "prvdr_SUB_DEV"
  features {}
  subscription_id = "3232323232-1bb1-5004-9779-6464646460"
}
provider "azurerm" {
  alias = "prvdr_SUB_QA"
  features {}
  subscription_id = "3232323232-1bb1-5004-9779-6464646461"
}
provider "azurerm" {
  alias = "prvdr_SUB_UAT"
  features {}
  subscription_id = "3232323232-1bb1-5004-9779-6464646462"
}
provider "azurerm" {
  alias = "prvdr_SUB_PROD"
  features {}
  subscription_id = "3232323232-1bb1-5004-9779-6464646463"
}
