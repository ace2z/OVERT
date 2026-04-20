/*
 ▮▮▮ Project APP STACK Specific - TAGS for resources 
*/
locals {
  project_tags = {
    ManagedBy    = "Terraform"
    ENVIRONMENT  = var.env_name
    PROJECT      = "TerryDEV"
    APPLICATION  = "TerryDEV"    
    OWNER        = "Terry J"
    TECH_CONTACT = "Terry J"
  }
}

