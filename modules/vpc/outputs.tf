output "vpc_id" {
  value = aws_vpc.this.id
}

output "subnet_id" {
  value = aws_subnet.this.id
}

output "security_group_ids" {
  value = aws_security_group.this.id
}

output "ami_id" {
  value = data.aws_ssm_parameter.this.value
}