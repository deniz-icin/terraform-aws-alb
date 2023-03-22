ingress_rules_instance = {
    "HTTP rule"  = {
        description = "Allow HTTP"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    },
    "HTTPS rule" = {
        description = "Allow HTTPs"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    },
    "SSH rule"   = {
        description = "Allow SSH"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

ingress_rules_alb = {
    "HTTP rule"  = {
        description = "Allow HTTP"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    },
    "HTTPS rule"  = {
        description = "Allow HTTPs"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

egress_rule = {
    "egress rule" = {
       from_port    = 0
       to_port      = 0
       protocol     = "-1"
       cidr_blocks  = ["0.0.0.0/0"]
    }
}

fixed_response = {
    "response body"  = {
        content_type = "text/plain"
        status_code  = 404
        message_body = "404: Page Not Found!"
    }
}
