variable "region" {
  description = "Web App Region"
  type        = string
  default     = "eu-central-1"
}

variable "vpc_cidr" {
  description = "IPv4 CIDR Block for VPC"
  type        = string
  default     = "172.168.0.0/16"
}

variable "dns_hostnames" {
  description = "Enable DNS Hostnames for VPC"
  type        = bool
  default     = true
}

variable "vpc_tag" {
  description = "Name of the VPC"
  type        = string
  default     = "webapp-vpc"
}

variable "availability_zones" {
  description = "AZs in current region to use"
  type        = list
  default     = ["eu-central-1a", "eu-central-1b"]
}

variable "subnet_cidrs_public" {
  description = "Subnet CIDRs for public subnets"
  type        = list
  default     = ["172.168.1.0/24", "172.168.2.0/24"]
}

variable "subnet_cidrs_private" {
  description = "Subnet CIDRs for private subnets"
  type        = list
  default     = ["172.168.3.0/24", "172.168.4.0/24"]
}

variable "public_subnet_tags" {
  description = "Public subnet names"
  type        = list
  default     = ["webapp_public_subnet_a","webapp_public_subnet_b"]
}

variable "private_subnet_tags" {
  description = "Private subnet names"
  type        = list
  default     = ["webapp_private_subnet_a","webapp_private_subnet_b"]
}

variable "rt_cidr_block_ipv4" {
  description = "Route table CIDR Block for IPv4"
  type        = string
  default     = "0.0.0.0/0"
}

variable "rt_cidr_block_ipv6" {
  description = "Route table CIDR Block for IPv6"
  type        = string
  default     = "::/0"
}

variable "rt_tag" {
  description = "Route table name"
  type        = string
  default     = "webapp_public_rt"
}

variable "sec_group_1_name" {
  description = "Allow HTTP/HTTPs and SSH traffic for servers"
  type        = string
  default     = "webapp_sg"
}

variable "sec_group_2_name" {
  description = "Allow HTTP/HTTPs traffic for load balancer"
  type        = string
  default     = "alb_sg"
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
  description = "Egress security group rules for all"
  type        = map
}

variable "ami_most_recent" {
  type        = bool
  default     = true  
}

variable "ami_owners" {
  description = "Owner of AMI's"
  type        = list
  default     = ["amazon"]
}

variable "ami_name" {
  description = "AMI names"
  type        = list
  default     = ["amzn2-ami-kernel-*-hvm-*"]
}

variable "ami_architecture" {
  description = "AMI Architectures"
  type        = list
  default     = ["x86_64"]
}

variable "ami_root_device_type" {
  description = "AMI Root Device types"
  type        = list
  default     = ["ebs"]
}

variable "ami_virtualization_type" {
  description = "AMI Virtualization Types"
  type        = list
  default     = ["hvm"]
}

variable "instance_type" {
  description = "Type of Instance"
  type        = string
  default     = "t2.micro"
}

variable "instance_1" {
  description = "Name of First Instance"
  type        = string
  default     = "webserver-1"
}

variable "instance_2" {
  description = "Name of Second Instance"
  type        = string
  default     = "webserver-2"
}

variable "instance_3" {
  description = "Name of Third Instance"
  type        = string
  default     = "webserver-3"
}

variable "public_ip_address" {
  description = "Associate a public IP address with an instance"
  type        = bool
  default     = true
}

variable "lb_name" {
  description = "Load Balancer Name"
  type        = string
  default     = "webappalb"
}

variable "load_balancer_type" {
  description = "Load Balancer Type"
  type        = string
  default     = "application"
}

variable "load_balancer_internal" {
  type        = bool
  default     = false
}
variable "listener_protocol" {
  description = "Type of listener protocol"
  type        = string
  default     = "HTTP"
}

variable "listener_port" {
  description = "Number of listener port"
  type        = number
  default     = 80
}

variable "listener_priority" {
  description = "The rule number of listener"
  type        = number
  default     = 100
}

variable "listener_default_action_type" {
  type        = string
  default     = "fixed-response"
}

variable "tg_name" {
  description = "Target group name"
  type        = string
  default     = "webapp-tg"
}

variable "tg_protocol" {
  description = "Type of target group protocol"
  type        = string
  default     = "HTTP"
}

variable "tg_port" {
  description = "Number of target group port"
  type        = number
  default     = 80
}

variable "fixed_response" {
  description = "Default 404 page body"
  type        = map
}

variable "listener_condition_value" {
  description = "Path pattern values"
  type        = list
  default     = ["*"]
}

variable "listener_action_type" {
  description = "Listener action type"
  type        = string
  default     = "forward"
}