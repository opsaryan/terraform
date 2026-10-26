resource "aws_security_group" "sg_lb" {
    name = "${var.project_name}-${var.environment}-lb"
    vpc_id = var.vpc_id
    tags = {
      Name = "${var.project_name}-${var.environment}-lb-sg"
    }
}

resource "aws_security_group_rule" "sg_lb_http" {
    security_group_id = aws_security_group.sg_lb.id
    type = "ingress"
    protocol = "tcp"
    to_port = 80
    from_port = 80
    cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "sg_lb_egress" {
    security_group_id = aws_security_group.sg_lb.id
    type = "egress"
    protocol = "-1"
    to_port = 0
    from_port = 0
    cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_lb" "load_balancer" {
    name = "${var.project_name}-${var.environment}-lb"
    load_balancer_type = "application"
    subnets = var.subnet_ids
    security_groups = [ aws_security_group.sg_lb.id ]
    tags = {
      Name = "${var.project_name}-${var.environment}-lb"
    }
}

resource "aws_lb_target_group" "instances" {
    name = "${var.project_name}-${var.environment}-tg"
    port = 80
    protocol = "HTTP"
    vpc_id = var.vpc_id
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

resource "aws_lb_target_group_attachment" "instances" {
    count = length(var.instance_ids)
    target_group_arn = aws_lb_target_group.instances.arn
    target_id = var.instance_ids[count.index]
    port = 80
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

resource "aws_lb_listener_rule" "http" {
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
