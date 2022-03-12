output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnet1_id" {
  value = aws_subnet.public-subnet-1.id
}
output "public_subnet2_id" {
  value = aws_subnet.public-subnet-2.id
}

output "private_subnet_id" {
  value = aws_subnet.private-subnet.id
}

output "security_group_ids" {
  value = aws_security_group.this.id
}

output "ami_id" {
  value = data.aws_ssm_parameter.this.value
}