// Otherwise, import and reference the 'global tags module' as shown below
module "gtags" {
  source = "https://github.com/ace2z/OVERT.git//Terraform_qrf/TFMOD_commun/aws/d2_globaltags"
}
//data "aws_availability_zones" "available" {}

// ▮▮▮ Create the EKS custom instances
module "eksINIT" {
  source     = "./modules/eks_d2custom"
  vpc_name   = "${var.vpc_name}_vpc"
  cidr_block = local.vpc_cidr_block

  # Concat 'project_tags' w global tags
  tags = merge(module.d2_global_tags, local.project_tags)
  
}


