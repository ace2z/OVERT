
#1. First build out the VPC
resource "aws_vpc" "vpc_main" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"
  tags             = var.tags

} # end of block

