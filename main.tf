terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region  = var.region
}

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = var.dns_hostnames

  tags = {
    Name = var.vpc_tag
  }
}

resource "aws_subnet" "public_1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_cidrs_public[0]
  availability_zone = var.availability_zones[0]

  tags = {
    Name = var.public_subnet_tags[0]
  }
}

resource "aws_subnet" "public_2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_cidrs_public[1]
  availability_zone = var.availability_zones[1]

  tags = {
    Name = var.public_subnet_tags[1]
  }
}

resource "aws_subnet" "private" {
  count             = length(var.subnet_cidrs_private)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_cidrs_private[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = element(var.private_subnet_tags, count.index)
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block      = var.rt_cidr_block_ipv4
    gateway_id      = aws_internet_gateway.internet_gateway.id
  }
  route {
    ipv6_cidr_block = var.rt_cidr_block_ipv6
    gateway_id      = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = var.rt_tag
  }
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "webapp_sg" {
  name        = var.sec_group_1_name
  vpc_id      = aws_vpc.vpc.id

  dynamic "ingress" {
    for_each = var.ingress_rules_instance
    content {
      description      = ingress.value.description
      from_port        = ingress.value.from_port
      to_port          = ingress.value.to_port
      protocol         = ingress.value.protocol
      cidr_blocks      = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = var.egress_rule
    content {
      from_port        = egress.value.from_port
      to_port          = egress.value.to_port
      protocol         = egress.value.protocol
      cidr_blocks      = egress.value.cidr_blocks
    }
  }
}

resource "aws_security_group" "alb_sg" {
  name        = var.sec_group_2_name
  vpc_id      = aws_vpc.vpc.id
  
  dynamic "ingress" {
    for_each = var.ingress_rules_alb
    content {
      description      = ingress.value.description
      from_port        = ingress.value.from_port
      to_port          = ingress.value.to_port
      protocol         = ingress.value.protocol
      cidr_blocks      = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = var.egress_rule
    content {
      from_port        = egress.value.from_port
      to_port          = egress.value.to_port
      protocol         = egress.value.protocol
      cidr_blocks      = egress.value.cidr_blocks
    }
  }
}

data "aws_ami" "linux_ami" {
  most_recent = var.ami_most_recent
  owners      = var.ami_owners

  filter {
    name   = "name"
    values = var.ami_name
  }
  filter {
    name   = "architecture"
    values = var.ami_architecture
  }
  filter {
    name   = "root-device-type"
    values = var.ami_root_device_type
  }
  filter {
    name   = "virtualization-type"
    values = var.ami_virtualization_type
  }
}

resource "aws_instance" "instance_1" {
  ami                         = data.aws_ami.linux_ami.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_1.id
  vpc_security_group_ids      = [aws_security_group.webapp_sg.id]
  associate_public_ip_address = var.public_ip_address

  user_data = "${file("init.sh")}"

  tags = {
    Name = var.instance_1
  }
}

resource "aws_instance" "instance_2" {
  ami                         = data.aws_ami.linux_ami.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_1.id
  vpc_security_group_ids      = [aws_security_group.webapp_sg.id]
  associate_public_ip_address = var.public_ip_address

  user_data = "${file("init.sh")}"

  tags = {
    Name = var.instance_2
  }
}

resource "aws_instance" "instance_3" {
  ami                         = data.aws_ami.linux_ami.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_2.id
  vpc_security_group_ids      = [aws_security_group.webapp_sg.id]
  associate_public_ip_address = var.public_ip_address

  user_data = "${file("init.sh")}"

  tags = {
    Name = var.instance_3
  }
}

resource "aws_lb" "load_balancer" {
  name               = var.lb_name
  internal           = var.load_balancer_internal
  load_balancer_type = var.load_balancer_type
  security_groups    = [aws_security_group.alb_sg.id]
  
  subnet_mapping {
    subnet_id     = aws_subnet.public_1.id
  }
  subnet_mapping {
    subnet_id     = aws_subnet.public_2.id
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.load_balancer.arn
  protocol          = var.listener_protocol
  port              = var.listener_port

  default_action {
    type = var.listener_default_action_type

  dynamic "fixed_response" {
    for_each = var.fixed_response
    content {
      content_type = fixed_response.value.content_type
      status_code  = fixed_response.value.status_code
      message_body = fixed_response.value.message_body
      }
    }
  }
}

resource "aws_lb_listener_rule" "listener_rule" {
  listener_arn = aws_lb_listener.listener.arn
  priority     = var.listener_priority

  condition {
    path_pattern {
      values = var.listener_condition_value
    }
  }

  action {
    target_group_arn = aws_lb_target_group.target_group.arn
    type             = var.listener_action_type
  }
}

resource "aws_lb_target_group" "target_group" {
  name     = var.tg_name
  protocol = var.tg_protocol
  port     = var.tg_port
  vpc_id   = aws_vpc.vpc.id
}

resource "aws_lb_target_group_attachment" "instance_1" {
  port             = var.tg_port
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = aws_instance.instance_1.id
}

resource "aws_lb_target_group_attachment" "instance_2" {
  port             = var.tg_port
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = aws_instance.instance_2.id
}

resource "aws_lb_target_group_attachment" "instance_3" {
  port             = var.tg_port
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = aws_instance.instance_3.id
}
