resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    "Name" = "my_vpc"
  }
}


# Use Data Source to get all Avalablility Zones in the region
data "aws_availability_zones" "available_zones" {}


/* This code leverages the aws_availability_zones data source,
  allowing you to dynamically fetch the list of Availability Zones available in your selected AWS region.
  By doing so, you can design your infrastructure to be resilient across multiple AZs,
   enhancing its fault tolerance and ensuring high availability */

# Create Public Subnet AZ1
resource "aws_subnet" "public_subnet_az1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_az1_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet AZ1"
  }
}

# Create Public Subnet AZ2
resource "aws_subnet" "public_subnet_az2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_az2_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet AZ2"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "VPC-IGW"
  }
}

# Create Public Route Table and add Public Route
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

# Associate Public Subnet AZ1 to "Public Route Table"
resource "aws_route_table_association" "public-subnet-az1-rt-association" {
  subnet_id      =  aws_subnet.public_subnet_az1.id
  route_table_id =  aws_route_table.public-route-table.id
}

# Associate Public Subnet AZ2 to "Public Route Table"
resource "aws_route_table_association" "public-subnet-2-rt-association" {
  subnet_id      =  aws_subnet.public_subnet_az2.id
  route_table_id = aws_route_table.public-route-table.id
}

# Create Private Subnet AZ1
resource "aws_subnet" "private_subnet_az1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_subnet_az1_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "Private Subnet AZ1"
  }
}

# Create Private Subnet AZ2
resource "aws_subnet" "private_subnet_az2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_subnet_az2_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = false

  tags = {
    Name = "Private Subnet AZ2"
  }
}

# Here is the configuration for creating NAT gateways:

# Allocate Elastic IP. (This EIP will be used for the Nat-Gateway in the Public Subnet AZ1)
resource "aws_eip" "eip_for_nat_gateway_az1" {
  domain    = "vpc"

  tags   = {
    Name = "Nat Gateway AZ1 EIP"
  }
}

# Allocate Elastic IP. (This EIP will be used for the Nat-Gateway in the Public Subnet AZ2)
resource "aws_eip" "eip_for_nat_gateway_az2" {
  domain    = "vpc"

  tags   = {
    Name = "Nat Gateway AZ2 EIP"
  }
}

# Create Nat Gateway in Public Subnet AZ1
resource "aws_nat_gateway" "nat_gateway_az1" {
  allocation_id = aws_eip.eip_for_nat_gateway_az1.id
  subnet_id     = aws_subnet.public_subnet_az1.id

  tags   = {
    Name = "Nat Gateway AZ1"
  }

  # to ensure proper ordering, it is recommended to add an explicit dependency
  depends_on = [aws_internet_gateway.igw]
}

# Create Nat Gateway in Public Subnet AZ2
resource "aws_nat_gateway" "nat_gateway_az2" {
  allocation_id = aws_eip.eip_for_nat_gateway_az2.id
  subnet_id     = aws_subnet.public_subnet_az2.id

  tags   = {
    Name = "Nat Gateway AZ2"
  }

  # to ensure proper ordering, it is recommended to add an explicit dependency on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

#Create Private Route Table for AZ1 and Add a Route Through NAT Gateway AZ1


# Create Private Route Table AZ1 and add route through Nat Gateway AZ1
resource "aws_route_table" "private_route_table_az1" {
  vpc_id            = aws_vpc.vpc.id

  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.nat_gateway_az1.id
  }

  tags   = {
    Name = "Private Route Table AZ1"
  }
}
# Associate Private Subnet AZ1 with Private Route Table AZ1

# Associate Private Subnet AZ1 with Private Route Table AZ1
resource "aws_route_table_association" "private_subnet_az1_route_table_az1_association" {
  subnet_id         = aws_subnet.private_subnet_az1.id
  route_table_id    = aws_route_table.private_route_table_az1.id
}

# Create Private Route Table for AZ2 and Add a Route Through NAT Gateway AZ2

# Create Private Route Table AZ2 and add route through Nat Gateway AZ2
resource "aws_route_table" "private_route_table_az2" {
  vpc_id            = aws_vpc.vpc.id

  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.nat_gateway_az2.id
  }

  tags   = {
    Name = "Private Route Table AZ2"
  }
}

# Associate Private Subnet AZ2 with Private Route Table AZ2

# Associate Private Subnet AZ2 with Private Route Table AZ2
resource "aws_route_table_association" "private_subnet_az2_route_table_az2_association" {
  subnet_id         = aws_subnet.private_subnet_az2.id
  route_table_id    = aws_route_table.private_route_table_az2.id
}