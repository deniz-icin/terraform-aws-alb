terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.59.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "eu-central-1"
}

resource "aws_vpc" "webapp_vpc" {
  cidr_block           = "172.168.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "webapp_vpc"
  }
}

resource "aws_subnet" "webapp_public_subnet" {
  vpc_id            = aws_vpc.webapp_vpc.id
  cidr_block        = "172.168.1.0/24"
  availability_zone = "eu-central-1a"

  tags = {
    Name = "webapp_public_subnet"
  }
}
resource "aws_subnet" "webapp_private_subnet" {
  vpc_id            = aws_vpc.webapp_vpc.id
  cidr_block        = "172.168.2.0/24"
  availability_zone = "eu-central-1a"

  tags = {
    Name = "webapp_private_subnet"
  }
}

resource "aws_internet_gateway" "webapp_ig" {
  vpc_id = aws_vpc.webapp_vpc.id

  tags = {
    Name = "webapp_ig"
  }
}

resource "aws_route_table" "webapp_public_rt" {
  vpc_id = aws_vpc.webapp_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.webapp_ig.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.webapp_ig.id
  }

  tags = {
    Name = "webapp_public_rt"
  }
}

resource "aws_route_table_association" "webapp_public_rt_a" {
  subnet_id      = aws_subnet.webapp_public_subnet.id
  route_table_id = aws_route_table.webapp_public_rt.id
}

resource "aws_security_group" "webapp_sg" {
  name        = "webapp_sg"
  description = "Allow HTTP and SSH traffic"
  vpc_id      = aws_vpc.webapp_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "webapp_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-*-hvm-*"]
  }

 filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "webapp_instance" {
  ami           = data.aws_ami.webapp_ami.id
  instance_type = "t2.micro"

  subnet_id                   = aws_subnet.webapp_public_subnet.id
  vpc_security_group_ids      = [aws_security_group.webapp_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
  #!/bin/bash
  yum update -y
  yum install -y httpd
  systemctl start httpd
  systemctl enable httpd
  echo "<h1>Basic Web App from $(hostname -f)</h1>"> /var/www/html/index.html
  EOF
  
  tags = {
    Name = "webapp-server"
  }
}