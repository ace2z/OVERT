
# Declare extra runtime tags here (from one place). These are tags that would apply to ALL resources in this code
locals {
  project_tags = {
    Application_id = "EKS D2 Revision"
    Environment    = "dev"
    Author      = "terry.j"
    LastDeployBy     = "terry.j"
  }
}

