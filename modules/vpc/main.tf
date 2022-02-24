provider "aws" {
  region = var.region
}
resource "aws_vpc" "this" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  
  tags = {
    Name        = "My Automated VPC"
    Description = "VPC created from Terraform workflow"
  }
}

resource "aws_subnet" "this" {
  vpc_id     = aws_vpc.this.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name        = "My Automated Public Subnet"
    Description = "Subnet created from Terraform workflow"
  }
}

resource "aws_subnet" "private-subnet" {
  vpc_id     = aws_vpc.this.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name        = "My Automated Private Subnet"
    Description = "Subnet created from Terraform workflow"
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
    Name        = "My Automated Security Group"
    Description = "My Automated Security Group"
  }
}

# create VPC Network access control list
resource "aws_network_acl" "this" {
  vpc_id = aws_vpc.this.id
  
  ingress {
    protocol   = "-1"
    rule_no    = 50
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = "-1"
    rule_no    = 50
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
resource "aws_route_table" "this" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "My Automated VPC Route Table"
  }
} # end resource

# Create the Internet Access
resource "aws_route" "internet_route" {
  route_table_id         = aws_route_table.this.id
  destination_cidr_block = var.destinationCIDRblock
  gateway_id             = aws_internet_gateway.this.id
} # end resource

# Associate the Route Table with the Subnet
resource "aws_route_table_association" "route_table_association" {
  subnet_id      = aws_subnet.this.id
  route_table_id = aws_route_table.this.id
} # end resource

data "aws_ssm_parameter" "this" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}