variable "domain_name" { type = string }

variable "ttl" { default = 86400 }
variable "use_TTL_hourly" { default = false } // Will configure the TTL to be hourly (3600 seconds) instead of daily (86400 seconds)
variable "use_TTL_fast" { default = false }   // Will configure the TTL to be 5 minutes (300 seconds) instead of daily (86400 seconds)

variable "workmail_txt" { default = "" } // if this is NOT BLANK, we will create required entries for AWS Workmail email domain resolution

// This is a series of flags to customize Route53 for a domain within Ace2z environmet
variable "config_www" { default = false }   // Configures a WWW record to the main ace2z WWWW ec2 server (or LB or k8s service)
variable "config_api" { default = false }   // Configures an "api.YOURDOMAIN.com" record that points to the ace2z APP Server (or LB or k8s service)
variable "config_mongo" { default = false } // Configures a mongo.YOURDOMAIN.com record that poitns to main monger cluster (or LB)



// All user specified A records (hostname --> ip address) 
variable "A_recs" {
  type        = map(any)
  default     = {}
  description = "Map List of A records. Only add the hostname (domain is auto appended)"
}

// All users specified CNAME records (hostname --> another FQDN ) 
variable "CNAME_recs" {
  type        = map(any)
  default     = {}
  description = "Map List of CNAME records. Only add the hostname (domain is auto appended)"
}

variable "AAAA_IPv6_recs" {
  type        = map(any)
  default     = {}
  description = "Map List of  host names ONLY (domain is auto appended)"
}

// Generics for ALL modules

variable "tags" {}




