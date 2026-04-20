output "vpc_id" {
  value = aws_vpc.vpc_main.id
}
output "vpc_arn" {
  value = aws_vpc.vpc_main.arn
}
output "vpc_cidr" {
  value = aws_vpc.vpc_main.cidr_block
}

output "default_network_acl_id" {
  value = aws_vpc.vpc_main.default_network_acl_id
}