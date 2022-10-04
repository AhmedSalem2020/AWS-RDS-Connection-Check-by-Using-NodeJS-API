# Child Module

/*==== The VPC ======*/
resource "aws_vpc" "vpc" {
  cidr_block           = "${var.VpcCIDR}"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name        = "${var.name}-vpc"
    CreatedBy   = "${var.mail}"
  }
}

/*==== The VPC Internet Gateway ======*/
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.name}-IGW"
    CreatedBy   = "${var.mail}"
  }
}

/*==== The Public subnets ======*/
resource "aws_subnet" "Public_Subnet1" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.PublicSubnet1CIDR}"
  availability_zone       = "${var.availability_zones[0]}"
  map_public_ip_on_launch = true
  tags = {
     Name        = "${var.name}-PublicSubnet1"
     CreatedBy   = "${var.mail}"
  }
}

resource "aws_subnet" "Public_Subnet2" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.PublicSubnet2CIDR}"
  availability_zone       = "${var.availability_zones[1]}"
  map_public_ip_on_launch = true
  tags = {
     Name        = "${var.name}-PublicSubnet2"
     CreatedBy   = "${var.mail}"
  }
}

/*==== The Private subnets ======*/
resource "aws_subnet" "private_subnet1" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.PrivateSubnet1CIDR}"
  availability_zone       = "${var.availability_zones[0]}"
  map_public_ip_on_launch = false
  tags = {
    Name        = "${var.name}-privatesubnet1"
    CreatedBy   = "${var.mail}"
  }
}

resource "aws_subnet" "private_subnet2" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.PrivateSubnet2CIDR}"
  availability_zone       = "${var.availability_zones[1]}"
  map_public_ip_on_launch = false
  tags = {
    Name        = "${var.name}-privatesubnet2"
    CreatedBy   = "${var.mail}"
  }
}

/* Elastic IP 1 for NAT 1 */
resource "aws_eip" "nat_eip1" {
  vpc        = true
  depends_on = [aws_internet_gateway.gw]
  tags = {
     Name        = "${var.name}-EIP1"
     CreatedBy   = "${var.mail}"
  }
}

/* Elastic IP 2 for NAT 2 */
resource "aws_eip" "nat_eip2" {
  vpc        = true
  depends_on = [aws_internet_gateway.gw]
  tags = {
     Name        = "${var.name}-EIP2"
     CreatedBy   = "${var.mail}"
  }
}
/* NAT 1 */
# To ensure proper ordering, it is recommended to add an explicit dependency on the Internet Gateway for the VPC.
resource "aws_nat_gateway" "NatGateway1" {
  allocation_id = "${aws_eip.nat_eip1.id}"
  subnet_id     = "${aws_subnet.Public_Subnet1.id}"
  depends_on    = [aws_internet_gateway.gw]
  tags = {
     Name        = "${var.name}-NatGateway1"
     CreatedBy   = "${var.mail}"
  }
}

/* NAT 2 */
resource "aws_nat_gateway" "NatGateway2" {
  allocation_id = "${aws_eip.nat_eip2.id}"
  subnet_id     = "${aws_subnet.Public_Subnet2.id}"
  depends_on    = [aws_internet_gateway.gw]
  tags = {
     Name        = "${var.name}-NatGateway2"
     CreatedBy   = "${var.mail}"
  }
}

/* Routing table for public subnets */
resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags = {
    Name        = "${var.name}-public-route-table"
    CreatedBy   = "${var.mail}"
  }
}

/* Routing tables for private subnets */
resource "aws_route_table" "private_route1" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags = {
    Name        = "${var.name}-private-route1-table"
    CreatedBy   = "${var.mail}"
  }
}
resource "aws_route_table" "private_route2" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags = {
    Name        = "${var.name}-private-route2-table"
    CreatedBy   = "${var.mail}"
  }
}

/* internet_gateway association with the Public Route table */
resource "aws_route" "public_internet_gateway" {
  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.gw.id}"
}

/* nat_gateway1 and nat_gateway2 association with the Private Route tables */
resource "aws_route" "private_nat_gateway1" {
  route_table_id         = "${aws_route_table.private_route1.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.NatGateway1.id}"
}

resource "aws_route" "private_nat_gateway2" {
  route_table_id         = "${aws_route_table.private_route2.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.NatGateway2.id}"
}

/* Public Route table associations with Public_Subnet1 and Public_Subnet2 */
resource "aws_route_table_association" "publicsub1" {
  subnet_id      = "${aws_subnet.Public_Subnet1.id}"
  route_table_id = "${aws_route_table.public.id}"
}
resource "aws_route_table_association" "publicsub2" {
  subnet_id      = "${aws_subnet.Public_Subnet2.id}"
  route_table_id = "${aws_route_table.public.id}"
}

/* private Route table associations with Private_Subnet1 and Private_Subnet2 */
resource "aws_route_table_association" "privatesub1" {
  subnet_id      = "${aws_subnet.private_subnet1.id}"
  route_table_id = "${aws_route_table.private_route1.id}"
}
resource "aws_route_table_association" "privatesub2" {
  subnet_id      = "${aws_subnet.private_subnet2.id}"
  route_table_id = "${aws_route_table.private_route2.id}"
}

/*==== VPC's Default Security Group ======*/
resource "aws_security_group" "default" {
  name        = "${var.name}-default-sg"
  description = "Default security group to allow inbound/outbound from the VPC"
  vpc_id      = "${aws_vpc.vpc.id}"
  depends_on  = [aws_vpc.vpc]
  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }
  
  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = "true"
  }
  tags = {
    CreatedBy   = "${var.mail}"
  }
}