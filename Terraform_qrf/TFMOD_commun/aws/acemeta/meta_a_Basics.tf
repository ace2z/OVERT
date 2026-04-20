# "Almost never changing" meta data to make future Terraform developmernt easier

locals {
  basics = {
    ACCOUNT_ID   = "11000268000"
    vpc_cidr     = "10.10.0.0/21"
    vpc_id       = "vpc-0000f87ba0f580000"
    LOCAL_SUBNET = "10.0.0.0/8"

    // Common CIDR blocks .. added here for convenience
    cidr_1019 = "10.10.0.0/22" // Cidr with 1019 available IP's
    cidr_2043 = "10.10.0.0/21" // Cidr with 2043 available IP's
    cidr_4091 = "10.10.0.0/20" // Cidr with 4091 available IP's    

    // Various EIP's we have configured. Route53 uses these most
    EIP_www     = "55.260.115.22"  
    EIP_Mongo   = "55.261.115.22" 
    EIP_Winslim = "55.262.115.22" 

    // EIP IDs ...for the resource types that need ID 
    eipID_www     = "eipalloc-0000000d9d8960000"
    eipID_Mongo   = "eipalloc-0000000d9d8960000"
    eipID_Winslim = "eipalloc-0000000d9d8960000"

  }

  // IMPORTANT. If you add new files with Meta locals in it, be SURE to update this merge block
  merged_output = merge(
    local.basics,
    local.service_ident,
    local.ec2_ami,
    local.misc
  )

}

// Merged output for all the meta data
output "md" {
  value       = local.merged_output
  description = "Ace2z AWS metadata"
}