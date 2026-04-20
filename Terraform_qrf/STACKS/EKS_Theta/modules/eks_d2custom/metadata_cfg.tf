
// Convenient metadata locals...Saved here for easy access elsewhere

locals {
  DEBUG_MODE = true

  TEST_ACCT_ID     = "110000000002"
  TARGET_DEV_ACCT_ID = "110000000003"

  ACCOUNT_ID = local.DEBUG_MODE ? local.TEST_ACCT_ID : local.TARGET_DEV_ACCT_ID

  vpc_cidr_block = "10.0.0.0/16"
  vpc_name       = "d2_${var.environment}"

  main_vpc_id     = module.vpcinit.vpc_id
  private_subids  = aws_subnet.private[*].id
  route_table_ids = aws_route_table.route_table_private[*].id

  PUBLIC_subids          = aws_subnet.pubsub[*].id
  PUBLIC_route_table_ids = aws_route_table.route_table_PUBLIC[*].id

  igw_id      = aws_internet_gateway.igw.id
  natgate_ids = aws_nat_gateway.natgate[*].id

  // for EKS
  eks_name = "d2-${var.environment}-eks-cluster"

  eks_node_volume_size  = 50
  eks_iops              = 2000
  eks_instance_type     = "m7i.4xlarge"
  eks_ng1_instance_type = "m8g.4xlarge"
  eks_ng2_instance_type = "c8g.4xlarge"

  eks_min_nodes    = 1
  eks_MAX_nodes    = 2
  eks_DESIRED_size = 1

  eks_sec_group_ids = [aws_security_group.eks_sg_443.id] //aws_security_group.eks_sg*[*].id
  #eks_ubuntu_ami_id       = "ami-07ee04759daf109de"            
  eks_sg_443_eks_from_ec2 = aws_security_group.eks_sg_443.id


  // IAM Arn for DEV, QA, PROD  - TBD: setup if statement to switch based on pipeline input
  TARGETDEV_IAM_PRINCIPAL_ARN = "arn:aws:iam::${local.ACCOUNT_ID}:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_AWSPowerUserAccess_5def73fa10dcb6fa"

  TEST_PRINCIPAL_ARN = aws_iam_role.aws_reserved_sso_role.arn

  // This is the Principal ARN that ACTUALLY gets used for EKS
  IAM_PRINCIPAL_ARN = local.TEST_PRINCIPAL_ARN


  eks_iam_sso_reserved_arn = local.IAM_PRINCIPAL_ARN
  eks_iam_ec2_instance_arn = aws_iam_role.eks_ec2_instance_role.arn
  eks_iam_bastion_role_arn = aws_iam_role.bastion_role.arn



}
