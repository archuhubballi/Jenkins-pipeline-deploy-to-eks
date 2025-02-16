# Create a VPC
resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "MyTerraformVPC"
  }
}

# Create a Public Subnet
resource "aws_subnet" "PublicSubnet-1" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-2a"

  tags = {
    Name = "MypPublicSubnet-1"
  }
}

resource "aws_subnet" "PublicSubnet-2" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-2b"

  tags = {
    Name = "MypPublicSubnet-2"
  }
}

# Create a Private Subnet
resource "aws_subnet" "PrivateSubnet-1" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-2a"

  tags = {
    Name = "MyPrivateSubnet-1"
  }
}

resource "aws_subnet" "PrivateSubnet-2" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "us-east-2b"

  tags = {
    Name = "MyPrivateSubnet-2"
  }
}

# Create IGW
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.myvpc.id
}

# Route table for Public Subnet
resource "aws_route_table" "PublicRT" {
  vpc_id = aws_vpc.myvpc.id

  route  {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }
}

# Route table associateion public subnet
resource "aws_route_table_association" "Publicsubnet-1RTassociation" {
  subnet_id = aws_subnet.PublicSubnet-1.id
  route_table_id = aws_route_table.PublicRT.id
}

resource "aws_route_table_association" "Publicsubnet-2RTassociation" {
  subnet_id = aws_subnet.PublicSubnet-2.id
  route_table_id = aws_route_table.PublicRT.id
}


# Create a Instance
#resource "aws_instance" "Demo_instance" {
#  ami = var.ami
#  instance_type = var.instance_type
#  subnet_id = aws_subnet.PublicSubnet.id
#}

# Elastic IP
#resource "aws_eip" "Demo_eip" {
#  instance = aws_instance.Demo_instance.id
#}
