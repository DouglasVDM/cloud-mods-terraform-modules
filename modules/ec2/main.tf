# 9. Create Ubuntu server and install/enable nginx
data "aws_availability_zones" "available_zones" {}

resource "aws_instance" "app-instance" {
  ami                         = var.ami
  instance_type               = var.instance_type
  availability_zone           = data.aws_availability_zones.available_zones.names[0]
  key_name                    = var.key_name
  subnet_id                   = var.public_subnet_az1_id
  vpc_security_group_ids      = [var.public_security_group_id]
  associate_public_ip_address = var.associate_public_ip_address

  user_data = <<-EOF
                #!/bin/bash
                echo "update packages"
                sudo apt update -y
                echo "install nginx"
                sudo apt install nginx -y
                sudo systemctl enable nginx
                EOF
  tags = {
    Name = "${var.project_name}-app-instance"
  }
}

resource "aws_network_interface" "network-interface" {
  subnet_id                   = var.public_subnet_az1_id
  private_ips     = ["10.11.1.50"]
  security_groups = [var.public_security_group_id]

  attachment {
    instance     = aws_instance.app-instance.id
    device_index = 1
  }
}
