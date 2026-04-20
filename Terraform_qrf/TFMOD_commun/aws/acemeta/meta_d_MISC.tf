// ▮▮▮ "Almost never changing" meta data to make future Terraform developmernt easier

locals {
  misc = {
    HOME_IPADDY_A = "98.00.31.261"
    HOME_IPADDY_B = "98.01.31.262"

    TRUSTED_SSO_ASSUME_ROLE_ARN = "arn:aws:iam::110002680002:role/ace2z_Reserved_AssumeSSO_Role"

    TRUSTED_SSO_ASSUME_ROLE_ARN_cbrew ashback_LOB = "arn:aws:iam::110002680002:role/ace2z_Reserved_AssumeSSO_Role"

    ec2_key_name = "ec2_terrystd_cloudkey" # This is the ssh keypair / key name for the ec2 instances

    MONGO_datavol_ID = "vol-0000e000f38320000"


    MONGO_fqdn = "qrfmongodb.aceqrf2z.com"
    WEB_fqdn   = "qrfweb-serv.aceqrf2z.com"
    API_fqdn   = "qrfapi-restws.aceqrf2z.com"

  }
  

}
