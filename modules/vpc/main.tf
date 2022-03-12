provider "aws" {
  region = var.region
}
resource "aws_vpc" "this" {
  cidr_block           = var.vpcCIDR
  enable_dns_hostnames = var.dnsHostNames

  tags = {
    Name        = "My Automated VPC"
    Description = "VPC created from Terraform workflow"
  }
}

resource "aws_subnet" "public-subnet-1" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.publicSubnet1CIDR
  availability_zone = "us-east-1a"

  tags = {
    Name = "My Automated Public Subnet 1"
  }
}

resource "aws_subnet" "public-subnet-2" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.publicSubnet2CIDR
  availability_zone = "us-east-1b"

  tags = {
    Name = "My Automated Public Subnet 2"
  }
}

resource "aws_subnet" "private-subnet" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.privateSubnet1CIDR
  availability_zone = var.availabilityZone

  tags = {
    Name = "My Automated Private Subnet"
  }
}


resource "aws_security_group" "this" {
  vpc_id = aws_vpc.this.id
  name   = "my-web-security-group"
  # allow ingress of port 22
  dynamic "ingress" {
    for_each = var.securityGroupRules
    content {
      cidr_blocks = ingress.value["cidr_blocks"]
      from_port   = ingress.value["port"]
      to_port     = ingress.value["port"]
      protocol    = ingress.value["protocol"]
    }
  }

  # allow egress of all ports
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "My Automated Security Group"
  }
}

# create VPC Network access control list
resource "aws_network_acl" "this" {
  vpc_id = aws_vpc.this.id

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "My Automated VPC ACL"
  }
} # end resource

# Create the Internet Gateway
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "My Automated VPC Internet Gateway"
  }
} # end resource

# Create the Route Table
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "My Automated Public Route Table"
  }
} # end resource

resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "My Automated Private Route Table"
  }
} # end resource

# Create the Internet Access
resource "aws_route" "internet_route" {
  route_table_id         = aws_route_table.public-route-table.id
  destination_cidr_block = var.destinationCIDRblock
  gateway_id             = aws_internet_gateway.this.id
} # end resource

resource "aws_route" "nat-route" {
  route_table_id         = aws_route_table.private-route-table.id
  destination_cidr_block = var.destinationCIDRblock
  nat_gateway_id         = aws_nat_gateway.this.id
} # end resource

# Associate the Route Table with the Subnet
resource "aws_route_table_association" "public-route-table-association" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.public-route-table.id
} # end resource

resource "aws_route_table_association" "private-route-table-association" {
  subnet_id      = aws_subnet.private-subnet.id
  route_table_id = aws_route_table.private-route-table.id
} # end resource

resource "aws_eip" "nat-eip" {
  vpc                       = true
  associate_with_private_ip = "10.0.0.10"

  tags = {
    Name = "My Automated NAT EIP"
  }
}

resource "aws_nat_gateway" "this" {
  # count = var.create_vpc && var.enable_nat_gateway ? local.nat_gateway_count : 0

  allocation_id = aws_eip.nat-eip.id
  subnet_id     = aws_subnet.public-subnet-1.id

  depends_on = [aws_eip.nat-eip]
}

data "aws_ssm_parameter" "this" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}