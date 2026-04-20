
module "acedev_io" {
  source = "git::https://github.com/ace2z/OVERT.git//Terraform_qrf/TFMOD_commun/aws/ace_dns"

  domain_name  = "acedev.io"
  use_TTL_fast = true
  workmail_txt = "XXXXXXXXXXXXXXX-XXXXXXXXXXXXX-XXXXXXXXXXXXXXXX-"

  # config_www   = true
  # config_mongo = true

  #}
  # This is so Positve_SSL certs from www.ssls.com  will work properly 
  CNAME_recs = {
    "_XXXXXXXXXXXXXXX" = {
      fqdn = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX.1F44XXXXXXXXXXXXXXX.XXXXXXXXXXXXXXX.comodoca.com"
    },
  }

  tags = merge(
    local.project_tags
  )
}


module "ace2z_com" {
  source = "git::https://github.com/ace2z/OVERT.git//Terraform_qrf/TFMOD_commun/aws/ace_dns"

  domain_name = "ace2z.com"
  //use_TTL_fast = true
  workmail_txt = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX="

  config_www   = true
  config_mongo = true

  A_recs = {
    "mongo-db" = {
      ip_addy = local.meta.EIP_Mongo
      //add_reverse_dns = true
    },
  }

  CNAME_recs = {
    "web-serv" = {
      fqdn = "ace2z.com"
    },
  }

  tags = merge(
    local.project_tags
  )
}


module "sacy_tv" {
  source = "git::https://github.com/ace2z/OVERT.git//Terraform_qrf/TFMOD_commun/aws/ace_dns"

  domain_name  = "sacy.tv"
  use_TTL_fast = true
  workmail_txt = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX="

  tags = merge(
    local.project_tags
  )
}



