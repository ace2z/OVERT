output "vpc_id" {
  value = aws_vpc.mainvpc.id
}
output "cidr_block" {
  value = aws_vpc.mainvpc.cidr_block
}


// Easy access to the subnet ids
output "subids" {
  value = {
    private = local.private_subids
    PUBLIC  = local.PUBLIC_subids
    CIDR_PUB = local.CIDRs_PUB
    CIDR_private = local.CIDRs_private
  }
}
