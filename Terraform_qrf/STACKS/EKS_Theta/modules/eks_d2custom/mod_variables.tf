variable "vpc_name" {
  description = "All tags items in this module"
  type        = string
  default     = "TerryTestEKS-VPC"
}

variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = ""
}

variable "enable_dns_support" {
  description = "Enable DNS support"
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames"
  type        = bool
  default     = true
}

variable "tags" {}
