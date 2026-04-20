variable "vpc_name" {}

variable "vpc_cidr" {}


# variable "map_public_ip_on_launch" {
#   default     = false
# }

variable "PUBLIC_subs" {}
variable "private_subs" {}


// Defaults to true. If this is ever FALSE...means we create a NAT Gateway for each private subnet
// This is useful for KUBERNETES
variable "need_multiple_natgate" {
  default = false
}


variable "skip_global_tags" { default = false }
variable "tags" {
  type    = map(string)
  default = {}
}




