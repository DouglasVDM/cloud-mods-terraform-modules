# 9. Create Ubuntu server and install/enable nginx
data "aws_availability_zones" "available_zones" {}

resource "aws_instance" "app_instance" {
  ami                         = var.ami
  instance_type               = var.instance_type
  availability_zone           = data.aws_availability_zones.available_zones.names[0]
  key_name                    = var.key_name
  subnet_id                   = var.public_subnet_az1_id
  vpc_security_group_ids      = [var.public_security_group_id]
  associate_public_ip_address = var.associate_public_ip_address

  user_data = file("../modules/ec2/user_data.sh")

  tags = {
    Name = "${var.project_name}_app_instance"
  }
}

