locals {

  pub_subs = ["10.0.40.0/24", "10.0.50.0/24", "10.0.60.0/24"]

}

// ▮▮▮ PUBLIC Subnets
resource "aws_subnet" "pubsub" {
  count = length(local.pub_subs)

  availability_zone    = length(regexall("^[a-z]{2}-", element(data.aws_availability_zones.available.names, count.index))) > 0 ? element(data.aws_availability_zones.available.names, count.index) : null
  availability_zone_id = length(regexall("^[a-z]{2}-", element(data.aws_availability_zones.available.names, count.index))) == 0 ? element(data.aws_availability_zones.available.names, count.index) : null
  cidr_block           = element(concat(local.pub_subs, [""]), count.index)

  vpc_id = local.main_vpc_id

  tags = merge({
    Name = "${local.eks_name}-PUBSUB-${count.index}"
    #"kubernetes.io/role/internal-elb" = "1"
    "Scope" = "PUBLIC Subnets"
    },
    var.tags
  )
}

// ▮▮▮ PUBLIC Route TABLE   3x (one for each PUBLIC SUB)
resource "aws_route_table" "route_table_PUBLIC" {
  count  = length(local.pub_subs)
  vpc_id = local.main_vpc_id

  tags = merge({
    Name = "PUBLIC-route-table-${local.eks_name}-${count.index}"
    },
    var.tags
  )
}

// ▮▮▮ PUBLIC Route TBL ASSOCIATIONS
resource "aws_route_table_association" "PUBLIC_assoc" {
  count = length(local.pub_subs)

  subnet_id      = element(aws_subnet.pubsub[*].id, count.index)
  route_table_id = element(aws_route_table.route_table_PUBLIC[*].id, count.index)
}


// ▮▮▮ Routes PUBLIC subnets to IGW
resource "aws_route" "IGW_route" {
  count = length(local.pub_subs)

  route_table_id         = local.PUBLIC_route_table_ids[count.index]
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id

  timeouts {
    create = "5m"
  }
}
