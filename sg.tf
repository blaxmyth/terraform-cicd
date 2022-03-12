resource "aws_security_group" "tradebot-elb-sg" {
  vpc_id = module.vpc.vpc_id
  name   = "tradebot-elb-sg"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # allow ingress of port 22
  #   dynamic "ingress" {
  #     for_each = var.securityGroupRules
  #     content {
  #       cidr_blocks = ingress.value["cidr_blocks"]
  #       from_port   = ingress.value["port"]
  #       to_port     = ingress.value["port"]
  #       protocol    = ingress.value["protocol"]
  #     }
  #   }

  #   # allow egress of all ports
  #   egress {
  #     from_port   = 0
  #     to_port     = 0
  #     protocol    = "-1"
  #     cidr_blocks = ["0.0.0.0/0"]
  #   }
  tags = {
    Name = "My ELB Security Group"
  }
}