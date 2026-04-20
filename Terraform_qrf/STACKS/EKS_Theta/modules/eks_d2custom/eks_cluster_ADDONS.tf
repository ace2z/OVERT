

resource "aws_eks_addon" "vpc-cni" {
  addon_name = "vpc-cni"
  // addon_version               = local.ADDON_VER
  addon_version               = "v1.18.6-eksbuild.1"
  cluster_name                = local.eks_name
  resolve_conflicts_on_create = "OVERWRITE"

  configuration_values = jsonencode({
    env = {
      # AWS_VPC_K8S_CNI_CUSTOM_NETWORK_CFG = "true"
      # ENI_CONFIG_LABEL_DEF               = "topology.kubernetes.io/zone"

      # Reference docs https://docs.aws.amazon.com/eks/latest/userguide/cni-increase-ip-addresses.html
      ENABLE_PREFIX_DELEGATION = "true"
      WARM_PREFIX_TARGET       = "1"
    }
  })

  depends_on = [
    module.eks

  ]
}


resource "aws_eks_addon" "coredns" {
  addon_name    = "coredns"
  cluster_name  = local.eks_name
  addon_version = "v1.11.3-eksbuild.2"

  resolve_conflicts_on_create = "OVERWRITE"

  depends_on = [
    module.eks,
    aws_eks_addon.vpc-cni
  ]
}


