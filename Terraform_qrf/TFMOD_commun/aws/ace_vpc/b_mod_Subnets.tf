#1b. cute little trick that lets me reference all AZ's sequencially (with array notation)
data "aws_availability_zones" "available" {}

locals {

  private_subids = aws_subnet.private_sub[*].id
  PUBLIC_subids  = aws_subnet.pubsub[*].id

  CIDRs_PUB     = aws_subnet.pubsub[*].cidr_block
  CIDRs_private = aws_subnet.private_sub[*].cidr_block

  total_private_subs = length(local.private_subids)
  total_PUB_subs     = length(local.PUBLIC_subids)

}



// Private Subnets
resource "aws_subnet" "private_sub" {
  count = length(var.private_subs)

  availability_zone    = length(regexall("^[a-z]{2}-", element(data.aws_availability_zones.available.names, count.index))) > 0 ? element(data.aws_availability_zones.available.names, count.index) : null
  availability_zone_id = length(regexall("^[a-z]{2}-", element(data.aws_availability_zones.available.names, count.index))) == 0 ? element(data.aws_availability_zones.available.names, count.index) : null
  cidr_block           = element(concat(var.private_subs, [""]), count.index)

  vpc_id = aws_vpc.mainvpc.id

  tags = merge(tomap({
    "Name" = "${var.vpc_name}_private_${count.index}",
    }),
    local.all_Module_TAGS
  )
}



// PUBLIC Subnets
resource "aws_subnet" "pubsub" {
  count = length(var.PUBLIC_subs)

  availability_zone    = length(regexall("^[a-z]{2}-", element(data.aws_availability_zones.available.names, count.index))) > 0 ? element(data.aws_availability_zones.available.names, count.index) : null
  availability_zone_id = length(regexall("^[a-z]{2}-", element(data.aws_availability_zones.available.names, count.index))) == 0 ? element(data.aws_availability_zones.available.names, count.index) : null
  cidr_block           = element(concat(var.PUBLIC_subs, [""]), count.index)

  vpc_id = aws_vpc.mainvpc.id

  tags = merge(tomap({
    "Name" = "${var.vpc_name}_PUBSUB_${count.index}",
    }),
    local.all_Module_TAGS
  )
}


