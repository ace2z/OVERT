locals {

  acedns_WORKMAIL_TXT_DOM_OWNER_REC = "_amazonses.${var.domain_name}"
  
  acedns_WORKMAIL_MX_REC = var.domain_name
  acedns_WORKMAIL_MX_VAL = "10 inbound-smtp.us-east-1.amazonaws.com"

  acedns_WORKMAIL_CNAME_REC = "autodiscover.${var.domain_name}"
  acedns_WORKMAIL_CNAME_VAL = "autodiscover.mail.us-east-1.awsapps.com"

}

# For MAIL to work, we'll need a TXT record and some other stuff
resource "aws_route53_record" "workmail_txt" {
  count   = var.workmail_txt != "" ? 1 : 0 // Only create if workmail_txt is not empty
  zone_id = data.aws_route53_zone.tmpzone.zone_id
  name    = local.acedns_WORKMAIL_TXT_DOM_OWNER_REC
  type    = "TXT"
  ttl     = local.TTL_2use
  records = [var.workmail_txt] # YOU ALWAYS HAVE TO GET THIS FROM AWS WORKMAIL CONSOLE
}


resource "aws_route53_record" "workmail_mx" {
  count   = var.workmail_txt != "" ? 1 : 0 // Only create if workmail_txt is not empty
  zone_id = data.aws_route53_zone.tmpzone.zone_id
  name    = local.acedns_WORKMAIL_MX_REC
  type    = "MX"
  ttl     = local.TTL_2use
  records = [
    local.acedns_WORKMAIL_MX_VAL,
  ]
}

resource "aws_route53_record" "workmail_cname" {
  count   = var.workmail_txt != "" ? 1 : 0 // Only create if workmail_txt is not empty
  zone_id = data.aws_route53_zone.tmpzone.zone_id
  name    = local.acedns_WORKMAIL_CNAME_REC
  type    = "CNAME"
  ttl     = local.TTL_2use
  records = [local.acedns_WORKMAIL_CNAME_VAL]
}



