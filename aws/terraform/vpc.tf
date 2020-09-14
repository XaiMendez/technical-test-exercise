# DEFAULT VPC
resource "aws_vpc" "default_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = "default_vpc"
  }
}

# INTERNET GATEWAY
resource "aws_internet_gateway" "default-igw" {
  vpc_id = aws_vpc.default_vpc.id
  tags = {
    Name = "default-igw"
  }
}

# SUBNET 1 us-east-2a
resource "aws_subnet" "us_east_2a_subnet_1" {
  map_public_ip_on_launch = true
  availability_zone       = element(var.az_names, 0)
  vpc_id                  = aws_vpc.default_vpc.id
  cidr_block              = element(var.subnet_cidr_blocks, 0)
  tags = {
    "Name" = "us_east_2a_subnet_1"
  }
}

# ELASTIC IP
resource "aws_eip" "EIP_01" {
}


# NAT GATEWAY
resource "aws_nat_gateway" "us_east_2a_NG" {
  subnet_id     = aws_subnet.us_east_2a_subnet_1.id
  allocation_id = aws_eip.EIP_01.id
  tags = {
    "Name" = "us_east_2a_NG"
  }
}

# ROUTE TABLE 
resource "aws_route_table" "route_table_public" {
  vpc_id = aws_vpc.default_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default-igw.id
  }
  tags = {
    "Name" = "route_table_public"
  }
}

# ROUTE TABLE ASSOCIATION
resource "aws_route_table_association" "PUBLIC_ASSO" {
  route_table_id = aws_route_table.route_table_public.id
  subnet_id      = aws_subnet.us_east_2a_subnet_1.id
}

# SECURITY GROUP
resource "aws_security_group" "linux_servers_sg" {
  vpc_id = aws_vpc.default_vpc.id
  name   = "linux_servers_sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "web_servers_sg"
  }

}


