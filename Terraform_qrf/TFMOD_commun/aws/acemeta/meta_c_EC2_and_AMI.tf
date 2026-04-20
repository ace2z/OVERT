# "Almost never changing" meta data to make future Terraform developmernt easier

locals {

  ec2_ami = {


    /*
     Remember: To get the marketplace search names you need for searching AMI's go to
     EC2 ---> AMI's ---> Public Images (dropdown) ---> Search for the AMI you want .. (via the AMI ID)

     YOU NEED 'SOURCE' and 'Owner #' 

     If you need to, GO TO AMI CATALOG and you can see the AMI-ID ...copy this and search for it in the Public Images
  */

    ami_UBUNTU       = "ubuntu*24.*" 
    ami_owner_UBUNTU = "ZZZZZZZ9477"

    ami_WINDOWS       = "Windows_Server-2022-English*"
    ami_owner_WINDOWS = "ZZZZZZZ1308"

    ami_AMAZON_LINUX = "al2023-ami-2023*" 
    ami_owner_AMAZON = "ZZZZZZZ2989"

    ami_MAC       = "amzn-ec2-macos*" 
    ami_owner_MAC = "ZZZZZZZ4472"

    // My Personal Images
    ami_owner_ace2z      = "110002680002"
    ami_CUST_linux_clean = "AMZN_Linux2023_graviton_Clean*"
    ami_CUST_winslim     = "WinSlim_m7a_or_m8a*"

    ami_CUST_WEBAPI = "ace-WEB-API_LINUX_*"
    ami_CUST_MONGO  = "ace_MONGO_DB_Mar2025*"



  } //end of ec2_ami

}