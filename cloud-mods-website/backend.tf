# store the terraform state file in s3
terraform {
  backend "s3" {
    bucket  = "cloud-mods-modules-remote-state"
    key     = "cloud-mods-website.tfstate"
    region  = "us-east-1"
    profile = "terraform-user"
  }
}