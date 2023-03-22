variable "region" {
  type = string
  default = "eu-central-1"
}

variable "vpc_cidr" {
  type = string
  default = "172.168.0.0/16"

}

variable "dns_hostnames" {
  type = bool
  default = true
}

variable "vpc_tag" {
  type = string
  default = "webapp-vpc"
}

variable "availability_zones" {
  description = "AZs in this region to use"
  default = ["eu-central-1a", "eu-central-1b"]
  type = list
}

variable "subnet_cidrs_public" {
  description = "Subnet CIDRs for public subnets"
  default = ["172.168.1.0/24", "172.168.2.0/24"]
  type = list
}

variable "subnet_cidrs_private" {
  type = list
  description = "Subnet CIDRs for private subnets"
  default = ["172.168.3.0/24", "172.168.4.0/24"]
}

variable "public_subnet_tags" {
  type = list
  default = ["webapp_public_subnet_a","webapp_public_subnet_b"]
}

variable "private_subnet_tags" {
  type = list
  default = ["webapp_private_subnet_a","webapp_private_subnet_b"]
}

variable "rt_cidr_block_ipv4" {
  type = string
  default = "0.0.0.0/0"
}

variable "rt_cidr_block_ipv6" {
  type = string
  default = "::/0"
}

variable "rt_tag" {
  type = string
  default = "webapp_public_rt"
}

variable "sec_group_1_name" {
  type = string
  default = "webapp_sg"
}
variable "sec_group_2_name" {
  type = string
  default = "alb_sg"
}
variable "ingress_rules_instance" {
  description = "Ingress security group rules for web servers"
  type        = map
}

variable "ingress_rules_alb" {
  description = "Ingress security group rules for load balancer"
  type        = map
}

variable "egress_rule" {
  description = "Egress security group rules"
  type        = map
}

variable "ami_most_recent" {
  type = bool
  default = true  
}

variable "ami_owners" {
  type = list
  default = ["amazon"]
}

variable "ami_name" {
  type = list
  default = ["amzn2-ami-kernel-*-hvm-*"]
}

variable "ami_architecture" {
  type = list
  default = ["x86_64"]
}

variable "ami_root_device_type" {
  type = list
  default = ["ebs"]
}

variable "ami_virtualization_type" {
  type = list
  default = ["hvm"]
}

variable "aws_subnets_name" {
  type = string
  default = "vpc-id"
}

variable "instance_count" {
  type = number
  default = 2
}

variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "public_ip_address" {
  type = bool
  default = true
}

variable "alb_name" {
  type = string
  default = "webappalb"
}

variable "load_balancer_type" {
  type = string
  default = "application"
}

variable "load_balancer_internal" {
  type = bool
  default = false
}
variable "listener_protocol" {
  type    = string
  default = "HTTP"
}

variable "listener_port" {
  type    = number
  default = 80
}

variable "listener_priority" {
  type    = number
  default = 100
  
}

variable "listener_default_action_type" {
  type    = string
  default = "fixed-response"
}

variable "tg_name" {
  type    = string
  default = "webapp-tg"
}

variable "tg_protocol" {
  type    = string
  default = "HTTP"
}

variable "tg_port" {
  type    = number
  default = 80
}

variable "fixed_response" {
  description = "Default 404 page body"
  type        = map
}

variable "listener_condition_value" {
  type    = list
  default = ["*"]
}

variable "listener_action_type" {
  type    = string
  default = "forward"
}