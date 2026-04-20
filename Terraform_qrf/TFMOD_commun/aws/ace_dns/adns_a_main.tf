
// ▮▮▮ Get the meta data and global Tags
module "acemeta" {
  source = "git::https://github.com/ace2z/OVERT.git//Terraform_qrf/TFMOD_commun/aws/acemeta"
}
module "acetags" {
  source           = "git::https://github.com/ace2z/OVERT.git//Terraform_qrf/TFMOD_commun/aws/acetags"
  skip_global_tags = var.skip_global_tags
}
locals {
  // Convenience locals
  meta = module.acemeta.md
  // includes ALL MODULE ALL tags including whats passed in
  all_Module_TAGS = merge(
    module.acetags.global_tags,
    var.tags
  )
}
// = = = = 
locals {
  TTL_Daily  = 86400
  TTL_Hourly = 3600
  TTL_FAST   = 300

  /*
   - If use_TTL_hourly is true, use TTL_Hourly
   - Otherwise, If use_TTL_fast is true, use TTL_FAST
   - Otherwise, If user passed a CUSTOM ttl value (something OTHER than 86400/TTL_Daily) we use THAT value
   - Finally if none of the above are true, we use the default TTL_Daily value
  */

  TTL_2use = var.use_TTL_hourly ? local.TTL_Hourly : (var.use_TTL_fast ? local.TTL_FAST : (var.ttl != local.TTL_Daily ? var.ttl : local.TTL_Daily))

}




// Pulls the Zone record set using the name of the domain
data "aws_route53_zone" "tmpzone" {
  name         = var.domain_name
  private_zone = false
}

// Create all A records (if any specified)
resource "aws_route53_record" "acedns_A_recs" {
  for_each = var.A_recs
  zone_id  = data.aws_route53_zone.tmpzone.zone_id
  name = "${each.key}.${var.domain_name}"
  type = "A"
  ttl  = local.TTL_2use

  records = [
    each.value["ip_addy"]
  ]
}

/* ▮▮▮ REVERS DNS records for every A record .. only from whats in the ALLOWED list
 reference:
 https://aws.amazon.com/blogs/aws/reverse-dns-for-ec2s-elastic-ip-addresses/
*/
# resource "aws_route53_record" "revDNS_A_recs" {
#   //count   = var.add_reverse_dns ? 1 : 0
#   for_each = local.revdns_allowed_list
#   zone_id  = data.aws_route53_zone.tmpzone.zone_id
#   name     = "${strrev("${each.value["ip_addy"]}")}.in-addr.arpa"
#   //name = join("", [strrev(each.value["ip_addy"]), ".in-addr.arpa"])
#   type = "PTR"
#   ttl  = local.TTL_2use
#   records = [
#     "${each.key}.${var.domain_name}",
#   ]
# }

# create CNAME records (if any specified)
resource "aws_route53_record" "acedns_CNAME_recs" {
  for_each = var.CNAME_recs
  zone_id  = data.aws_route53_zone.tmpzone.zone_id
  name     = "${each.key}.${var.domain_name}"
  type     = "CNAME"
  ttl      = local.TTL_2use

  records = [
    each.value["fqdn"],
  ]
}
