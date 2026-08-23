terraform {
  backend "s3" {
    bucket = "terraform-state-s3-encrypted"
    key = "terraform/state"
    region = "ap-south-1"
    dynamodb_table = "terraform_state_table"
    encrypt = true
  }
  
  required_providers {
    aws = {
      source = "hashicorp/aws",
      version = "~> 6.0"
    }
  }
}

provider "aws" {
    region = "ap-south-1"
}

resource "aws_s3_bucket" "terraform_state" {
    bucket = "terraform-state-s3-encrypted"
    tags = {
      "isTerraformRemoteBackend" = "true"
    }
}

resource "aws_s3_bucket_versioning" "terraform_state_version" {
    bucket = aws_s3_bucket.terraform_state.id
    versioning_configuration {
      status = "Enabled"
    }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_encryption" {
    bucket = aws_s3_bucket.terraform_state.id
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
}

resource "aws_dynamodb_table" "dynamodb_state" {
    name = "terraform_state_table"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"
    attribute {
      name = "LockID"
      type = "S"
    }
}

resource "aws_vpc" "terraform_vpc" {
    cidr_block = "192.168.0.0/16"
}

resource "aws_subnet" "terraform_subnet_1" {
    vpc_id = aws_vpc.terraform_vpc.id
    cidr_block = "192.168.0.0/18"
    availability_zone = "ap-south-1a"
}

resource "aws_subnet" "terraform_subnet_2" {
    vpc_id = aws_vpc.terraform_vpc.id
    cidr_block = "192.168.64.0/18"
    availability_zone = "ap-south-1b"
}

resource "aws_internet_gateway" "terraform_internet_gateway" {
    vpc_id = aws_vpc.terraform_vpc.id
}

resource "aws_route_table" "terraform_lb_rt" {
    vpc_id = aws_vpc.terraform_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.terraform_internet_gateway.id
    }
}

resource "aws_security_group" "terraform_sg_lb" {
    vpc_id = aws_vpc.terraform_vpc.id
}

resource "aws_security_group_rule" "terraform_sg_lb_https" {
    security_group_id = aws_security_group.terraform_sg_lb.id
    type = "ingress"
    protocol = "tcp"
    to_port = 443
    from_port = 443
    cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "terraform_sg_lb_http" {
    security_group_id = aws_security_group.terraform_sg_lb.id
    type = "ingress"
    protocol = "tcp"
    to_port = 80
    from_port = 80
    cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "terraform_sg_lb_icmp" {
    security_group_id = aws_security_group.terraform_sg_lb.id
    type = "ingress"
    protocol = "icmp"
    from_port = -1
    to_port = -1
    cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "terraform_sg_lb_ssh" {
    security_group_id = aws_security_group.terraform_sg_lb.id
    type = "ingress"
    protocol = "tcp"
    to_port = 22
    from_port = 22
    cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "terraform_sg_lb_egress" {
    security_group_id = aws_security_group.terraform_sg_lb.id
    type = "egress"
    protocol = "-1"
    to_port = 0
    from_port = 0 
    cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group" "terraform_sg_instances" {
    name = "sg_instances"
    vpc_id = aws_vpc.terraform_vpc.id
}

resource "aws_security_group_rule" "terraform_sg_instance_http" {
    security_group_id = aws_security_group.terraform_sg_instances.id
    type = "ingress"
    protocol = "tcp"
    to_port = 80
    from_port = 80
    cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "terraform_sg_instance_egress" {
    security_group_id = aws_security_group.terraform_sg_instances.id
    type = "egress"
    protocol = "-1"
    to_port = 0
    from_port = 0 
    cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_instance" "instance_1" {
    ami = "ami-006f82a1d5a27da54"
    instance_type = "t3.micro"
    # security_groups = [ aws_security_group.terraform_sg_instances.name ]
    subnet_id = aws_subnet.terraform_subnet_1.id
    vpc_security_group_ids = [ aws_security_group.terraform_sg_instances.id ]
    user_data = <<-EOF
                #!/bin/bash
                echo "Hello, World 1" > index.html
                python3 -m http.server 80 &
                EOF
}

resource "aws_instance" "instance_2" {
    ami = "ami-006f82a1d5a27da54"
    instance_type = "t3.micro"
    # security_groups = [ aws_security_group.terraform_sg_instances.name ]
    subnet_id = aws_subnet.terraform_subnet_1.id
    vpc_security_group_ids = [ aws_security_group.terraform_sg_instances.id ]
    user_data = <<-EOF
                #!/bin/bash
                echo "Hello, World 2" > index.html
                python3 -m http.server 80 &
                EOF
}

resource "aws_lb" "load_balancer" {
    name = "web-app-lb"
    load_balancer_type = "application"
    subnets = [ aws_subnet.terraform_subnet_1.id, aws_subnet.terraform_subnet_2.id ]
    security_groups = [ aws_security_group.terraform_sg_lb.id ]
}

resource "aws_lb_listener" "http" {
    load_balancer_arn = aws_lb.load_balancer.arn
    port = 80
    protocol = "HTTP"
    default_action {
      type = "fixed-response"
      fixed_response {
        content_type = "text/plain"
        message_body = "404: Page not found"
        status_code = 404
      }
    }
}

resource "aws_lb_target_group" "instances" {
    name = "target-groups"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.terraform_vpc.id
    health_check {
      path = "/"
      port = 80
      protocol = "HTTP"
      matcher = "200"
      interval = 15
      timeout = 5
      healthy_threshold = 2
      unhealthy_threshold = 2
    }
}

resource "aws_lb_target_group_attachment" "target_instance_1" {
    target_group_arn = aws_lb_target_group.instances.arn
    target_id = aws_instance.instance_1.id
    port = 80
}

resource "aws_lb_target_group_attachment" "target_instance_2" {
    target_group_arn = aws_lb_target_group.instances.arn
    target_id = aws_instance.instance_2.id
    port = 80
}

resource "aws_lb_listener_rule" "lb_listener_rule" {
    listener_arn = aws_lb_listener.http.arn
    priority = 100
    condition {
      path_pattern {
        values = [ "*" ]
      }
    }
    action {
      type = "forward"
      target_group_arn = aws_lb_target_group.instances.arn
    }
}

resource "aws_route53_zone" "primary" {
    name = "zaren.me"
}

resource "aws_route53_record" "root" {
    zone_id = aws_route53_zone.primary.zone_id
    name = "zaren.me"
    type = "A"

    alias {
      name = aws_lb.load_balancer.dns_name
      zone_id = aws_lb.load_balancer.zone_id
      evaluate_target_health = true
    }
}
