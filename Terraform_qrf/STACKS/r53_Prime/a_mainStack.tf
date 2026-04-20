# = = = =
# Get the meta data and global Tags
# = = = =
module "acemeta" {
  source = "git::https://github.com/ace2z/OVERT.git//Terraform_qrf/TFMOD_commun/aws/acemeta"
}
module "acetags" {
  source = "git::https://github.com/ace2z/OVERT.git//Terraform_qrf/TFMOD_commun/aws/acetags"
}

locals {
  // Convenience locals
  meta        = module.acemeta.md
  global_tags = module.acetags.global_tags

  // includes ALL tags .. for resources NOT using modules
  allTAGS = merge(
    local.global_tags,
    local.project_tags
  )
}
# = = = = 
# = = = = 
locals {
  domain_list = [
    "acedev.io",  
    "ace2z.com",  
    "sacy.tv",    
  ]


  TTL_SHORT = 150
  TTL_Hour  = 3600
  TTL_Day   = 86400


  default_TTL = local.TTL_Day
}
// First create zones
resource "aws_route53_zone" "ALL_ZONES" {
  for_each = toset(local.domain_list)
  name     = each.value
}
