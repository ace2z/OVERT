// ▮▮▮ EIPs  (need one for each Natgate)

resource "aws_eip" "eip_natgate" {
  count = length(local.private_subids)
  tags = merge({
    Name                  = "${local.vpc_name}-EIP-EKS-NATGATE-${count.index}",
    eip-allocation-bypass = ""
    },
    var.tags
  )
}


// ▮▮▮ Create Internet Gateway (needed by NAT Gateway)
resource "aws_internet_gateway" "igw" {
  vpc_id = local.main_vpc_id

  tags = merge({
    Name = "${local.vpc_name}-IGW-InternetGateway"
    },
    var.tags
  )
}

// ▮▮▮  Nat Gateway 
resource "aws_nat_gateway" "natgate" {
  count = length(local.private_subids)

  allocation_id = aws_eip.eip_natgate[count.index].id
  subnet_id     = local.private_subids[count.index]

  tags = merge({
    Name = "${local.eks_name}-NATGATE-${count.index}"
    },
    var.tags
  )

  depends_on = [
    aws_internet_gateway.igw
  ]
}


/* ▮▮▮ Routing Tables for mapping PRIVATE subs to NAT Gateways
 Anything to 0.0.0.0 goes to the NAT Gateway 
 (being outside the private 10.x.x.x space) 
 */
resource "aws_route" "nat_gateway_route" {
  count = length(local.private_subids)

  route_table_id         = local.route_table_ids[count.index]
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.natgate[count.index].id

  timeouts {
    create = "5m"
  }
}
