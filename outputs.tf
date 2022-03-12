output "vpc_id" {
  value = module.vpc.vpc_id
}

output "jenkins_public_dns" {
  description = "Public DNS name of jenkins server"
  value       = aws_instance.jenkins.public_dns
}

output "prometheus_public_dns" {
  description = "Public DNS name of promotheus server"
  value       = aws_instance.prometheus.public_dns
}

output "ecr_repo_url" {
  value = aws_ecr_repository.tradebot.repository_url
}

# output "elb_dns" {
#   value = aws_elb.tradebot-elb.dns_name
# }