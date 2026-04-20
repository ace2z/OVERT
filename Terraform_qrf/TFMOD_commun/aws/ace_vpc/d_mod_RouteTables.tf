#1. Now lets create some routing tables. One gets bound to the IGW.. 
resource "aws_route_table" "route_IGW" {
  vpc_id = aws_vpc.mainvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }


  tags = merge(tomap({
    "Name" = "${var.vpc_name}_Route_to_IGW_PUBLIC",
    }),
    local.all_Module_TAGS
  )

}


resource "aws_route_table" "route_NATGATE" {
  count  = local.total_2_create
  vpc_id = aws_vpc.mainvpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = local.natgate_ids[count.index] #"${aws_nat_gateway.natgate.id}"
  }

  tags = merge(tomap({
    "Name" = "${var.vpc_name}_Route_Private_to_NATGATE_${count.index}",
    }),
    local.all_Module_TAGS
  )
}

# = = = Now do Associations = = =
resource "aws_route_table_association" "pubsub_route_assoc" {
  count          = length(var.PUBLIC_subs)
  subnet_id      = aws_subnet.pubsub[count.index].id
  route_table_id = aws_route_table.route_IGW.id
}

resource "aws_route_table_association" "private_route_assoc" {
  count          = local.total_private_subs
  subnet_id      = local.private_subids[count.index]
  route_table_id = local.total_2_create == 1 ? aws_route_table.route_NATGATE[0].id : aws_route_table.route_NATGATE[count.index].id
}

// also remove anything int he default route table (and tag with a disclaimer
resource "aws_default_route_table" "def_route_table" {
  default_route_table_id = aws_vpc.mainvpc.default_route_table_id

  route = []

  tags = {
    Name = "!!_DEFAULT_DO_NOT_USE_!!"
  }
}
