# create security group for the ec2 instance
resource "aws_security_group" "public_security_group" {
  name        = "${var.project_name}_public_security_group"
  description = "allow access on ports 22, 80, 443 and 5001"
  vpc_id      = var.vpc_id

  ingress {
    description      = "http access including my ip"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0", "102.65.62.201/32"]
    ipv6_cidr_blocks = ["::/0"]
  }


  ingress {
    description      = "https access including my ip"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0", "102.65.62.201/32"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "api server access"
    from_port        = 5001
    to_port          = 5001
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }


  ingress {
    description = "ssh access laptop"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["102.134.74.41/32"]
  }

  ingress {
    description = "ssh access desktop"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["102.65.62.201/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}_public_security_group"
  }
}
