# configure aws provider
provider "aws" {
  region  = var.region
  profile = "terraform-user"
}

# create vpc
module "vpc" {
  source                  = "../modules/vpc"
  region                  = var.region
  project_name            = var.project_name
  vpc_cidr                = var.vpc_cidr
  public_subnet_az1_cidr  = var.public_subnet_az1_cidr
  public_subnet_az2_cidr  = var.public_subnet_az2_cidr
  private_subnet_az1_cidr = var.private_subnet_az1_cidr
  private_subnet_az2_cidr = var.private_subnet_az2_cidr
}

# create security-groups
module "security-groups" {
  source                 = "../modules/security-groups"
  project_name           = var.project_name
  vpc_id                 = module.vpc.vpc_id
  public_subnet_az1_cidr = var.public_subnet_az1_cidr
}

# create ec2
module "ec2" {
  source                   = "../modules/ec2"
  project_name             = var.project_name
  public_subnet_az1_id     = module.vpc.public_subnet_az1_id
  public_security_group_id = module.security-groups.public_security_group_id
  key_name                 = var.key_name

}
