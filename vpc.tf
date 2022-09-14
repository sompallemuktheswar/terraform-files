
#create vpc
resource "aws_vpc" "vpc" {
  cidr_block       = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "chinnu" 
  }
}

#create IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "IGW"
  }
}

#Availability Zones
data "aws_availability_zones" "available" {
  state = "available"
}

#create public subnets
resource "aws_subnet" "public-sub" {
  count = length(data.aws_availability_zones.available.names)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = element(var.pub-sub,count.index)
  map_public_ip_on_launch = "true"
  availability_zone = element(data.aws_availability_zones.available.names,count.index)

  tags = {
    Name = "Stage-public-${count.index+1}"
  }
}
resource "aws_subnet" "private-sub" {
  count = length(data.aws_availability_zones.available.names)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = element(var.private-sub,count.index)
  map_public_ip_on_launch = "true"
  availability_zone = element(data.aws_availability_zones.available.names,count.index)

  tags = {
    Name = "Stage-private-${count.index+1}"
  }
}

resource "aws_subnet" "data-sub" {
  count = length(data.aws_availability_zones.available.names)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = element(var.data-sub,count.index)
  map_public_ip_on_launch = "true"
  availability_zone = element(data.aws_availability_zones.available.names,count.index)

  tags = {
    Name = "Stage-private-${count.index+1}"
  }
}

#Create EIP
resource "aws_eip" "eip" {
  vpc = true
}

#create Nat gatway
resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public-sub[0].id

  tags = {
    Name = "NAT gw"
  }
}

#create Public Route Tables
resource "aws_route_table" "public-route" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public Route"
  }
}

#create Private Route Tables
resource "aws_route_table" "private-route" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw.id
  }

  tags = {
    Name = "private-route"
  }
}

#create Public subnet association
resource "aws_route_table_association" "public-asso" {
  count = length(aws_subnet.public-sub[*].id)
  subnet_id      = element(aws_subnet.public-sub[*].id,count.index)
  route_table_id = aws_route_table.public-route.id
}

#create Private subnet association
resource "aws_route_table_association" "private-asso" {
  count = length(aws_subnet.private-sub[*].id)
  subnet_id      = element(aws_subnet.private-sub[*].id,count.index)
  route_table_id = aws_route_table.private-route.id
}

#create Private subnet association
resource "aws_route_table_association" "data-asso" {
  count = length(aws_subnet.private-sub[*].id)
  subnet_id      = element(aws_subnet.data-sub[*].id,count.index)
  route_table_id = aws_route_table.private-route.id
}
