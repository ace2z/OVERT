locals {
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

// PRIVATE Subnets
resource "aws_subnet" "private" {
  count = length(local.private_subnets)

  availability_zone    = length(regexall("^[a-z]{2}-", element(data.aws_availability_zones.available.names, count.index))) > 0 ? element(data.aws_availability_zones.available.names, count.index) : null
  availability_zone_id = length(regexall("^[a-z]{2}-", element(data.aws_availability_zones.available.names, count.index))) == 0 ? element(data.aws_availability_zones.available.names, count.index) : null
  cidr_block           = element(concat(local.private_subnets, [""]), count.index)

  #vpc_id               = data.aws_vpcs.id.ids[0]
  vpc_id = local.main_vpc_id

  tags = merge({
    Name                              = "${local.eks_name}-private-subnet-${count.index}"
    "kubernetes.io/role/internal-elb" = "1"
    "Scope"                           = "Private Subnet"
    },
    var.tags
  )
}

// Route TABLE   3x (one for each Private subnet)
resource "aws_route_table" "route_table_private" {
  count  = length(local.private_subnets)
  vpc_id = local.main_vpc_id

  tags = merge({
    Name = "private-route-table-${local.eks_name}-${count.index}"
    },
    var.tags
  )
}

// Route TBL ASSOCIATIONS
resource "aws_route_table_association" "private" {
  count = length(local.private_subnets)

  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = element(aws_route_table.route_table_private[*].id, count.index)
}
