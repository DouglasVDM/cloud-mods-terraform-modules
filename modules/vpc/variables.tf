# environment variables
variable "region" {}
variable "project_name" {}

# vpc variables
variable "vpc_cidr" {}
variable "public_subnet_az1_cidr" {}
variable "public_subnet_az2_cidr" {}
variable "private_subnet_az1_cidr" {}
variable "private_subnet_az2_cidr" {}

variable "app_instance_id" {}
variable "public_security_group_id" {}

# ec2 variables
variable "key_name" {}