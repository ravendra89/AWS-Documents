provider "aws" {
  region = "ap-south-1"
  profile = "terraform_user"
}
resource "aws_vpc" "test" {
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"
    tags = {
      Name = "my-vpc"
    }
  
}
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.test.id
  
}
resource "aws_subnet" "sub-1" {
    vpc_id = aws_vpc.test.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "ap-south-1b"
    map_public_ip_on_launch = true
  
}

resource "aws_route_table" "RT" {
    vpc_id = aws_vpc.test.id
    route = {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

}
resource "aws_route_table_association" "sub-association" {
    subnet_id = aws_subnet.sub-1.id
    route_table_id = aws_route_table.RT.id
  
}