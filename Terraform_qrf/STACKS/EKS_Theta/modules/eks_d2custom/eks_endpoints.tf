
# Define VPC Endpoints for EKS
resource "aws_vpc_endpoint" "ep_eks" {
  vpc_id            = local.main_vpc_id
  service_name      = "com.amazonaws.${var.region}.eks"
  vpc_endpoint_type = "Interface"
  subnet_ids        = local.private_subids

  security_group_ids = [aws_security_group.eks_sg_443.id]

  // Finally the tags
  tags = merge({
    Name = "${local.eks_name}-eks-endpoint"
    },
    var.tags
  )
}


resource "aws_vpc_endpoint" "ep_ec2" {
  vpc_id            = local.main_vpc_id
  service_name      = "com.amazonaws.${var.region}.ec2"
  vpc_endpoint_type = "Interface"
  subnet_ids        = local.private_subids

  security_group_ids = [aws_security_group.eks_sg_443.id]

  // Finally the tags
  tags = merge({
    Name = "${local.eks_name}-eks-endpoint"
    },
    var.tags
  )
}

resource "aws_vpc_endpoint" "ep_ecr_api" {
  vpc_id            = local.main_vpc_id
  service_name      = "com.amazonaws.${var.region}.ecr.api"
  vpc_endpoint_type = "Interface"
  subnet_ids        = local.private_subids

  security_group_ids = [aws_security_group.eks_sg_443.id]

  // Finally the tags
  tags = merge({
    Name = "${local.eks_name}-eks-endpoint"
    },
    var.tags
  )
}


resource "aws_vpc_endpoint" "ep_ecr_dkr" {
  vpc_id            = local.main_vpc_id
  service_name      = "com.amazonaws.${var.region}.ecr.dkr"
  vpc_endpoint_type = "Interface"
  subnet_ids        = local.private_subids

  security_group_ids = [aws_security_group.eks_sg_443.id]

  // Finally the tags
  tags = merge({
    Name = "${local.eks_name}-eks-endpoint"
    },
    var.tags
  )
}

resource "aws_vpc_endpoint" "ep_s3" {
  vpc_id            = local.main_vpc_id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Interface"
  subnet_ids        = local.private_subids

  security_group_ids = [aws_security_group.eks_sg_443.id]

  // Finally the tags
  tags = merge({
    Name = "${local.eks_name}-eks-endpoint"
    },
    var.tags
  )
}

resource "aws_vpc_endpoint" "ep_elb" {
  vpc_id            = local.main_vpc_id
  service_name      = "com.amazonaws.${var.region}.elasticloadbalancing"
  vpc_endpoint_type = "Interface"
  subnet_ids        = local.private_subids

  security_group_ids = [aws_security_group.eks_sg_443.id]

  // Finally the tags
  tags = merge({
    Name = "${local.eks_name}-eks-endpoint"
    },
    var.tags
  )
}


resource "aws_vpc_endpoint" "ep_xray" {
  vpc_id            = local.main_vpc_id
  service_name      = "com.amazonaws.${var.region}.xray"
  vpc_endpoint_type = "Interface"
  subnet_ids        = local.private_subids

  security_group_ids = [aws_security_group.eks_sg_443.id]

  // Finally the tags
  tags = merge({
    Name = "${local.eks_name}-eks-endpoint"
    },
    var.tags
  )
}

resource "aws_vpc_endpoint" "ep_logs" {
  vpc_id            = local.main_vpc_id
  service_name      = "com.amazonaws.${var.region}.logs"
  vpc_endpoint_type = "Interface"
  subnet_ids        = local.private_subids

  security_group_ids = [aws_security_group.eks_sg_443.id]

  // Finally the tags
  tags = merge({
    Name = "${local.eks_name}-eks-endpoint"
    },
    var.tags
  )
}


resource "aws_vpc_endpoint" "ep_sts" {
  vpc_id            = local.main_vpc_id
  service_name      = "com.amazonaws.${var.region}.sts"
  vpc_endpoint_type = "Interface"
  subnet_ids        = local.private_subids

  security_group_ids = [aws_security_group.eks_sg_443.id]

  // Finally the tags
  tags = merge({
    Name = "${local.eks_name}-eks-endpoint"
    },
    var.tags
  )
}