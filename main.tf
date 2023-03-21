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

resource "aws_vpc" "terraform_vpc" {
  cidr_block           = "172.168.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "terraform_vpc"
  }
}

resource "aws_subnet" "terraform_public_subnet" {
  vpc_id            = aws_vpc.terraform_vpc.id
  cidr_block        = "172.168.1.0/24"
  availability_zone = "1a"

  tags = {
    Name = "terraform_public_subnet"
  }
}
resource "aws_subnet" "terraform_private_subnet" {
  vpc_id            = aws_vpc.terraform_vpc.id
  cidr_block        = "172.168.2.0/24"
  availability_zone = "1a"

  tags = {
    Name = "terraform_private_subnet"
  }
}

resource "aws_internet_gateway" "terraform_ig" {
  vpc_id = aws_vpc.terraform_vpc.id

  tags = {
    Name = "terraform_ig"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.terraform_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform_ig.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.terraform_ig.id
  }

  tags = {
    Name = "public_rt"
  }
}

resource "aws_route_table_association" "public_1_rt_a" {
  subnet_id      = aws_subnet.terraform_public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "terraform_sg" {
  name        = "terraform_sg"
  description = "Allow HTTP and SSH traffic"
  vpc_id      = aws_vpc.terraform_vpc.id

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

resource "aws_instance" "tf-server" {
  ami           = "ami-0499632f10efc5a62"
  instance_type = "t2.micro"

  subnet_id                   = aws_subnet.terraform_public_subnet.id
  vpc_security_group_ids      = [aws_security_group.terraform_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
  #!/bin/bash
  yum update -y
  yum install -y httpd
  systemctl start httpd
  systemctl enable httpd
  echo "<h1>Hello World from $(hostname -f)<hh>"> /var/www/html/index.html
  EOF
  
  tags = {
    Name = "tf_server"
  }
}