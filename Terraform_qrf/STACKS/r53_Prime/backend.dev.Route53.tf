terraform {
  backend "s3" {
    bucket         = "ZZZZZ-ZZZZZ-state-bucket" // MUST ALREADY EXIST
    dynamodb_table = "ZZZZZ-ZZZZZ-lock_tble"     // MUST ALREADY EXIST
    key            = "ZZZZZ/ZZZZZ.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}
