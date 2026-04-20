variable "tenant_id" {
  description = "Tenant_ID"
  type        = string
  default     = "ZZZZZZZZZZZZZZZZZZZZZZ"
}

// For establishing the ENV Context
variable "env_name" {
  description = "Environment Name / Context (dev/qa/uat/sandbox/PROD)"
  type        = string
}
variable "LOCATION" { default = "eastus" } 

variable "client_id" {
  description = "servprincipal client"
  type        = string
  default     = ""
}

variable "client_secret" {
  description = "servprincipal secret"
  type        = string
  default     = ""
}

variable "subscription_id" {
  description = "subid"
  type        = string
}

# Backend state generics
variable "resource_group_name" {}
variable "storage_account_name" {}
variable "container_name" {}
variable "key" {}



