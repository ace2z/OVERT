locals {
  total_2_create = var.need_multiple_natgate ? local.total_private_subs : 1

  natgate_ids = aws_nat_gateway.natgate[*].id
}


// Create Internet Gateway (needed by NAT Gateway)
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.mainvpc.id

  tags = merge(tomap({
    "Name" = "${var.vpc_name}-IGW",
    }),
    local.all_Module_TAGS
  )
}

// Need EIPs for natgateways
resource "aws_eip" "eip_natgate" {
  count = local.total_2_create

  tags = merge(tomap({
    "Name" = "${var.vpc_name}-EIP-for-NATGATE-${count.index}",
    }),
    local.all_Module_TAGS
  )
}


//  Actual Nat Gateway 
resource "aws_nat_gateway" "natgate" {
  count = local.total_2_create

  allocation_id = aws_eip.eip_natgate[count.index].id
  subnet_id     = local.private_subids[count.index]

  tags = merge(tomap({
    "Name" = "${var.vpc_name}-NATGATE-${count.index}",
    }),
    local.all_Module_TAGS
  )

  depends_on = [
    aws_internet_gateway.igw
  ]
}
