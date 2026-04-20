# Define IAM Role for AWS Reserved SSO
resource "aws_iam_role" "aws_reserved_sso_role" {

  name = "aws-reserved-sso-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${local.ACCOUNT_ID}:root"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge({
    "Name" = "${local.eks_name}_aws-reserved-sso-role",
    },
    var.tags
  )
}

# Attach ROLE 
resource "aws_iam_role_policy_attachment" "attach_aws_reserved_sso_role_policy" {
  role       = aws_iam_role.aws_reserved_sso_role.name
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
  depends_on = [
    aws_iam_role.aws_reserved_sso_role
  ]
}


# custom Inline policy (as found in hou account )
resource "aws_iam_role_policy" "custom_role_policy" {
  name   = "custom-role-policy"
  role   = aws_iam_role.aws_reserved_sso_role.id
  policy = file("${path.module}/iam_inline_principal_reserved_sso_policy.json")
  depends_on = [
    aws_iam_role.aws_reserved_sso_role
  ]

}