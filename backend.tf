terraform {
  backend "s3" {
    bucket = "blaxmyth-terraform-remote-state"
    key    = "prod/infra.tfstate"
    region = "us-east-1" //bucket region
  }
}