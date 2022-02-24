variable "region" {
  type    = string
  default = "us-east-1"
}
# variable "access_key" {
#      default = "<PUT IN YOUR AWS ACCESS KEY>"
# }
# variable "secret_key" {
#      default = "<PUT IN YOUR AWS SECRET KEY>"
# }
# variable "region" {
#      default = "us-east-1"
# }
variable "availabilityZone" {
  default = "us-east-1a"
}
variable "instanceTenancy" {
  default = "default"
}
variable "dnsSupport" {
  default = true
}
variable "dnsHostNames" {
  default = true
}
variable "vpcCIDRblock" {
  default = "10.0.0.0/16"
}
variable "subnetCIDRblock" {
  default = "10.0.1.0/24"
}
variable "destinationCIDRblock" {
  default = "0.0.0.0/0"
}
variable "ingressCIDRblock" {
  type    = list(any)
  default = ["0.0.0.0/0"]
}
variable "egressCIDRblock" {
  type    = list(any)
  default = ["0.0.0.0/0"]
}
variable "mapPublicIP" {
  default = true
}

variable "securityGroupRules" {
  default = [
    {
      port        = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      port        = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      port        = 8080
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      port        = 9090
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      port        = 9093
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      port        = 9100
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "ingressNetworkAclRules" {
  default = [
    {
      rule_no    = 100
      from_port  = 22
      to_port    = 22
      protocol   = "tcp"
      cidr_block = ["0.0.0.0/0"]
      action     = "allow"
    },
    {
      rule_no    = 200
      from_port  = 80
      to_port    = 80
      protocol   = "tcp"
      cidr_block = ["0.0.0.0/0"]
      action     = "allow"
    },
    {
      rule_no    = 300
      from_port  = 443
      to_port    = 443
      protocol   = "tcp"
      cidr_block = ["0.0.0.0/0"]
      action     = "allow"
    },
    {
      rule_no    = 400
      from_port  = 1024
      to_port    = 65535
      protocol   = "tcp"
      cidr_block = ["0.0.0.0/0"]
      action     = "allow"
    },
    {
      rule_no    = 500
      from_port  = 8080
      to_port    = 8080
      protocol   = "tcp"
      cidr_block = ["0.0.0.0/0"]
      action     = "allow"
    }
  ]
}

variable "egressNetworkAclRules" {
  default = [
    {
      rule_no    = 100
      from_port  = 22
      to_port    = 22
      protocol   = "tcp"
      cidr_block = ["0.0.0.0/0"]
      action     = "allow"
    },
    {
      rule_no    = 200
      from_port  = 80
      to_port    = 80
      protocol   = "tcp"
      cidr_block = ["0.0.0.0/0"]
      action     = "allow"
    },
    {
      rule_no    = 300
      from_port  = 443
      to_port    = 443
      protocol   = "tcp"
      cidr_block = ["0.0.0.0/0"]
      action     = "allow"
    },
    {
      rule_no    = 400
      from_port  = 1024
      to_port    = 65535
      protocol   = "tcp"
      cidr_block = ["0.0.0.0/0"]
      action     = "allow"
    },
    {
      rule_no    = 500
      from_port  = 8080
      to_port    = 8080
      protocol   = "tcp"
      cidr_block = ["0.0.0.0/0"]
      action     = "allow"
    }
  ]
}
# end of variables.tf