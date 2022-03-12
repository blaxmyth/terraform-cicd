# resource "aws_key_pair" "webkey" {
#     key_name = "webkey"
# }

variable "main_region" {
  type    = string
  default = "us-east-1"
}

provider "aws" {
  region = var.main_region
}

module "vpc" {
  source = "./modules/vpc"
  region = var.main_region
}

resource "aws_instance" "jenkins" {
  ami                         = module.vpc.ami_id
  subnet_id                   = module.vpc.public_subnet1_id
  instance_type               = "t2.micro"
  key_name                    = "webkey"
  associate_public_ip_address = true
  vpc_security_group_ids      = [module.vpc.security_group_ids]

  provisioner "remote-exec" {
    inline = [
      # "sudo yum -y install httpd && sudo systemctl start httpd",
      # "echo '<h1>My Web Server from Terraform Provioner</h1>' > index.html",
      # "sudo mv index.html /var/www/html"
      # innstall python and pip
      "sudo yum update -y",
      "sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo",
      "sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key",
      "sudo yum upgrade",
      "sudo yum install -y yum-utils jenkins git terraform",
      "sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo",
      "sudo amazon-linux-extras install java-openjdk11 epel python3.8 docker ansible2 -y",
      "sudo systemctl enable jenkins",
      "sudo systemctl enable docker",
      "sudo systemctl start jenkins",
      "sudo systemctl start docker",
      "sudo systemctl status jenkins",
      "sudo usermod -a -G docker ec2-user",
    ]
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/webkey.pem")
      host        = self.public_ip
    }
  }

  # provisioner "file" {

  #   source = "~/.ssh/webkey.pem"
  #   destination = "~/.ssh/webkey.pem"

  #   connection {
  #     type        = "ssh"
  #     user        = "ec2-user"
  #     private_key = file("~/.ssh/webkey.pem")
  #     host        = self.public_ip
  #   }
  # }
  tags = {
    Name = "jenkins"
  }
}

resource "aws_instance" "prometheus" {
  ami                         = module.vpc.ami_id
  subnet_id                   = module.vpc.public_subnet1_id
  instance_type               = "t2.micro"
  key_name                    = "webkey"
  associate_public_ip_address = true
  vpc_security_group_ids      = [module.vpc.security_group_ids]

  provisioner "remote-exec" {
    inline = [
      # "sudo yum -y install httpd && sudo systemctl start httpd",
      # "echo '<h1>My Web Server from Terraform Provioner</h1>' > index.html",
      # "sudo mv index.html /var/www/html"
      "sudo useradd --no-create-home prometheus",
      "sudo mkdir /etc/prometheus",
      "sudo mkdir /var/lib/prometheus",
      "wget https://github.com/prometheus/prometheus/releases/download/v2.19.0/prometheus-2.19.0.linux-amd64.tar.gz",
      "tar xvfz prometheus-2.19.0.linux-amd64.tar.gz",
      "sudo cp prometheus-2.19.0.linux-amd64/prometheus /usr/local/bin",
      "sudo cp prometheus-2.19.0.linux-amd64/promtool /usr/local/bin/",
      "sudo cp -r prometheus-2.19.0.linux-amd64/consoles /etc/prometheus",
      "sudo cp -r prometheus-2.19.0.linux-amd64/console_libraries /etc/prometheus",
      "rm -rf prometheus-2.19.0.linux-amd64.tar.gz prometheus-2.19.0.linux-amd64"
    ]
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/webkey.pem")
      host        = self.public_ip
    }
  }
  tags = {
    Name = "prometheus"
  }
}