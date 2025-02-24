# Configure the AWS Provider
provider "aws" {
  region = "ap-south-1"
}


#Create VPC 
resource "aws_vpc" "vpc_terra" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "vpc_terra"
  }
}

#Create IGW
resource "aws_internet_gateway" "igw_terra" {
  vpc_id = aws_vpc.vpc_terra.id

  tags = {
    Name = "igw_terra"
  }
}

#Create subnet
resource "aws_subnet" "subnet_terra" {
  vpc_id     = aws_vpc.vpc_terra.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "subnet_terra"
  }
}

#Create route table 
resource "aws_route_table" "route_terra" {
  vpc_id = aws_vpc.vpc_terra.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_terra.id
  }

  tags = {
    Name = "route_terra"
  }
}

#Create route-table subnet association
resource "aws_route_table_association" "route_sub_terra" {
  subnet_id      = aws_subnet.subnet_terra.id
  route_table_id = aws_route_table.route_terra.id
}

#Create Security group
resource "aws_security_group" "allow_all" {
  name        = "allow_tls"
  description = "Allow all inbound and outbound traffic"
  vpc_id      = aws_vpc.vpc_terra.id

  ingress {
    description = "TLS from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_all"
  }
}