# Create Security Group(s) for EKS
resource "aws_security_group" "eks_sg_443" {
  vpc_id = local.main_vpc_id

  tags = merge({
    Name = "eks_inbound_443"
    },
    var.tags
  )

  # Ingress rules
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["192.0.2.0/24"] // RFC 5737 non-routable placebolder
    description = "Allow Inbound 443"
  }

  # Egress rules
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }
}
