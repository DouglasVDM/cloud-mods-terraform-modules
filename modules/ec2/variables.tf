variable "project_name" {}

variable "ami" {
  type        = string
  description = "ami of ec2 instance"
  default     = "ami-085925f297f89fce1"
}

variable "instance_type" {
  type        = string
  description = "instance type of ec2"
  default     = "t2.micro"
}

variable "key_name" {}
variable "public_subnet_az1_id" {}
variable "public_security_group_id" {}

variable "associate_public_ip_address" {
  type        = bool
  description = "to assign or not to assign public ip address based on the boolean value"
  default       = true
}