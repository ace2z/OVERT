# Define IAM Role for EKS EC2 Instances
resource "aws_iam_role" "eks_ec2_instance_role" {
  name = "${local.eks_name}_ec2_instance_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge({
    "Name" = "${local.eks_name}_ec2_instance_role",
    },
    var.tags
  )

}

# Attach Policies to the IAM Role
resource "aws_iam_role_policy_attachment" "eks_ec2_instance_attach" {
  role       = aws_iam_role.eks_ec2_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly" # Required policy for EKS worker nodes
}

resource "aws_iam_role_policy_attachment" "eks_ec2_instance_attach2" {
  role       = aws_iam_role.eks_ec2_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy" # Required policy for EKS CNI
}

resource "aws_iam_role_policy_attachment" "eks_ec2_instance_attach3" {
  role       = aws_iam_role.eks_ec2_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_ec2_instance_attach4" {
  role       = aws_iam_role.eks_ec2_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "eks_ec2_instance_attach5" {
  role       = aws_iam_role.eks_ec2_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedEC2InstanceDefaultPolicy"
}
resource "aws_iam_role_policy_attachment" "eks_ec2_instance_attach6" {
  role       = aws_iam_role.eks_ec2_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
resource "aws_iam_role_policy_attachment" "eks_ec2_instance_attach7" {
  role       = aws_iam_role.eks_ec2_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMPatchAssociation"
}
resource "aws_iam_role_policy_attachment" "eks_ec2_instance_attach8" {
  role       = aws_iam_role.eks_ec2_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}
resource "aws_iam_role_policy_attachment" "eks_ec2_instance_attach9" {
  role       = aws_iam_role.eks_ec2_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}



