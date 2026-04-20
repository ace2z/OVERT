locals {
  // The "veks" prefix is to avoid conflicts. Everything with veks is variable ONLY used here in this EKS code

  veks_eks_name   = local.eks_name
  veks_vpc_id     = local.main_vpc_id
  veks_sec_groups = local.eks_sec_group_ids
  //  veks_ami_id        = local.eks_ubuntu_ami_id
  veks_instance_type = local.eks_instance_type

  veks_ng_default_name = "default-ng"
  veks_ng1_name        = "grafana-ng"
  veks_ng2_name        = "memcache-ng"

  veks_ng1_instance_type   = local.eks_ng1_instance_type
  veks_ng2_instance_type   = local.eks_ng2_instance_type
  veks_sg_443_eks_from_ec2 = local.eks_sg_443_eks_from_ec2

  veks_iam_ec2_instance_role_arn = local.eks_iam_ec2_instance_arn
  veks_iam_principle_arn         = local.eks_iam_sso_reserved_arn
  veks_iam_role_bastion_arn      = local.eks_iam_bastion_role_arn

  veks_node_volume_size = local.eks_node_volume_size
  veks_iops             = local.eks_iops
  veks_min_nodes        = local.eks_min_nodes
  veks_MAX_nodes        = local.eks_MAX_nodes
  veks_DESIRED_size     = local.eks_DESIRED_size

}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.26.0"
  create  = var.create_cluster

  vpc_id       = local.veks_vpc_id
  subnet_ids   = local.private_subids
  cluster_name = local.veks_eks_name

  cluster_version        = "1.30" // 1.30 is in staging...but 1.31 is latest
  cluster_upgrade_policy = "STANDARD"

  # new feature
  bootstrap_self_managed_addons = true

  cluster_additional_security_group_ids = local.veks_sec_groups
  cluster_endpoint_public_access        = false
  cluster_endpoint_private_access       = true
  create_node_security_group            = true
  cluster_ip_family                     = "ipv4"

  eks_managed_node_group_defaults = {
    use_custom_launch_template = false
    create_iam_role            = false
    iam_role_arn               = local.veks_iam_ec2_instance_role_arn
    metadata_options = {
      http_tokens = "required"
    }
    block_device_mappings = {
      xvda = {
        device_name = "/dev/xvda"
        ebs = {
          volume_size           = local.veks_node_volume_size
          volume_type           = "gp3"
          iops                  = local.veks_iops
          throughput            = 200
          encrypted             = true
          delete_on_termination = true
        }
      }
    }

    launch_template_tags = merge({
      "EksClusterName" = "${local.veks_eks_name}",
      },
          var.tags,
      
    )
  } //end of managed node group defaults

  

  cluster_security_group_additional_rules = {
    ingress_self_all = {
      description = "VPC to cluster all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      cidr_blocks = [local.vpc_cidr_block]
    },
    inress_ec2_tcp = {
      description              = "Access EKS from EC2 instance."
      protocol                 = "tcp"
      from_port                = 443
      to_port                  = 443
      type                     = "ingress"
      source_security_group_id = local.veks_sg_443_eks_from_ec2 //data.aws_security_group.ssm_sg.id
    }
  }

  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      cidr_blocks = [local.vpc_cidr_block]
    },
    node_to_node_communication = {
      description = "Allow full access for cross-node communication"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
  }

  enable_cluster_creator_admin_permissions = true

  access_entries = {
    poweruser = {
      kubernetes_groups = []
      principal_arn     = local.veks_iam_principle_arn

      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
          access_scope = {
            namespaces = []
            type       = "cluster"
          }
        }
        cluster_admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            namespaces = []
            type       = "cluster"
          }
        }
      }
    }
    bastion = {
      kubernetes_groups = []
      principal_arn     = local.veks_iam_role_bastion_arn

      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
          access_scope = {
            namespaces = []
            type       = "cluster"
          }
        }
        cluster_admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            namespaces = []
            type       = "cluster"
          }
        }
      }
    }
  }

  // Finally the tags
  tags = merge({
    Name = "${local.eks_name}"
    },
    var.tags
  )

  // Depends
  depends_on = [
    module.vpcinit,
    aws_nat_gateway.natgate,
    aws_internet_gateway.igw,
    aws_vpc_endpoint.ep_eks,
    aws_vpc_endpoint.ep_ec2,
    aws_vpc_endpoint.ep_ecr_api,
    aws_vpc_endpoint.ep_ecr_dkr,
    aws_vpc_endpoint.ep_s3,
    aws_vpc_endpoint.ep_elb,
    aws_vpc_endpoint.ep_xray,
    aws_vpc_endpoint.ep_logs,
    aws_vpc_endpoint.ep_sts
  ]

}
