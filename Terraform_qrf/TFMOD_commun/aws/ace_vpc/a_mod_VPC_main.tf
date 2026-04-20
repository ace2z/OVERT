// Get the meta data and global Tags
// = = = =
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


#2. First build out the VPC
resource "aws_vpc" "mainvpc" {
  cidr_block       = var.vpc_cidr # 21 == 2043 hosts, 22 == 109x hosts
  instance_tenancy = "default"

  tags = merge(tomap({
    "Name" = var.vpc_name,
    }),
    local.all_Module_TAGS
  )


} # end of block


# Delete the default security group
resource "aws_default_security_group" "kill_def_secgroup" {
  vpc_id = aws_vpc.mainvpc.id

  ingress = []
  egress  = []

  tags = {
    Name        = "!!!!!_DEFAULT_SECGROUP_DO_NOT_USE_!!!!!"
    Description = "!!!!!_DEFAULT_SECGROUP_DO_NOT_USE_!!!!!"
  }
}