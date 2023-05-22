# create vpc
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}_vpc"
  }
}

# create internet gateway and attach it to vpc
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project_name}_igw"
  }
}

# use data source to get all avalablility zones in region
data "aws_availability_zones" "available_zones" {}

# create public subnet az1
resource "aws_subnet" "public_subnet_az1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_az1_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}_public_subnet_az1"
  }
}

# create public subnet az2
resource "aws_subnet" "public_subnet_az2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_az2_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}_public_subnet_az2"
  }
}

# create private subnet az1
resource "aws_subnet" "private_subnet_az1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_subnet_az1_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[3]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.project_name}_private_subnet_az1"
  }
}

# create private subnet az2
resource "aws_subnet" "private_subnet_az2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_subnet_az2_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[4]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.project_name}_private_subnet_az2"
  }
}

# create route table and add public route
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "${var.project_name}_public_route_table"
  }
}

# associate public subnet az1 to "public route table"
resource "aws_route_table_association" "public_subnet_az1_route_table_association" {
  subnet_id      = aws_subnet.public_subnet_az1.id
  route_table_id = aws_route_table.public_route_table.id
}

# associate public subnet az2 to "public route table"
resource "aws_route_table_association" "public_subnet_az2_route_table_association" {
  subnet_id      = aws_subnet.public_subnet_az2.id
  route_table_id = aws_route_table.public_route_table.id
}

# create route table and add private route
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project_name}_private_route_table"
  }
}

# associate private subnet az1 to "private route table"
resource "aws_route_table_association" "private_subnet_az1_route_table_association" {
  subnet_id      = aws_subnet.private_subnet_az1.id
  route_table_id = aws_route_table.private_route_table.id
}

# associate private subnet az2 to "private route table"
resource "aws_route_table_association" "private_subnet_az2_route_table_association" {
  subnet_id      = aws_subnet.private_subnet_az2.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_db_subnet_group" "db_subnet" {
  name       = "${var.project_name}_db_subnet"
  subnet_ids = [aws_subnet.public_subnet_az1.id, aws_subnet.public_subnet_az2.id, aws_subnet.private_subnet_az1.id, aws_subnet.private_subnet_az2.id]

  tags = {
    Name = "${var.project_name}_db_subnet"
  }
}

resource "aws_network_interface" "public_network_interface" {
  subnet_id       = aws_subnet.public_subnet_az1.id
  private_ips     = ["10.11.1.50"]
  security_groups = [var.public_security_group_id]

  attachment {
    instance     = var.app_instance_id
    device_index = 1
  }
}

resource "aws_eip" "elastic_ip" {
  vpc                       = true
  network_interface         = aws_network_interface.public_network_interface.id
  associate_with_private_ip = "10.11.1.50"
  depends_on                = [aws_internet_gateway.internet_gateway]
}
