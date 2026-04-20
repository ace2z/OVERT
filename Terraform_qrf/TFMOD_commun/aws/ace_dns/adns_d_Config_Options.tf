// = = = for the DOM ONLY record  ie: mydomain.com 
// We MUST use an IP address for the root domain A record (cname IS NOT allowed)
resource "aws_route53_record" "dom_only_webrec" {
  count   = var.config_www ? 1 : 0
  zone_id = data.aws_route53_zone.tmpzone.zone_id
  name    = var.domain_name
  type    = "A"
  ttl     = local.TTL_2use
  records = [
    local.meta.EIP_www,
  ]
}

// Now, Create www record which will always point to the DOM ONLY record
resource "aws_route53_record" "www_rec" {
  count   = var.config_www ? 1 : 0 // only create if they didnt override with godaddy
  zone_id = data.aws_route53_zone.tmpzone.zone_id
  name    = "www.${var.domain_name}"
  type    = "CNAME"
  ttl     = local.TTL_2use
  records = [
    var.domain_name,
  ]
}



resource "aws_route53_record" "mongo_rec" {
  count   = var.config_mongo ? 1 : 0 // only create if they didnt override with godaddy
  zone_id = data.aws_route53_zone.tmpzone.zone_id
  name    = "mongo.${var.domain_name}"
  type    = "CNAME"
  ttl     = local.TTL_2use
  records = [
    local.meta.MONGO_fqdn,
  ]
}



