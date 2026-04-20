variable "vpc_name" {}
variable "environment" {
  description = "Configured in the pipeline ex: dev, qa, prod"
  default     = "dev"
}

variable "region" {
  description = "Region"
  default     = "us-east-1"
}

variable "create_cluster" {
  type        = bool
  description = "Trigger to create EKS cluster."
  default     = true
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.28"
}
