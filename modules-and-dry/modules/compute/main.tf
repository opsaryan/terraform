resource "aws_security_group" "sg_servers" {
  name   = "${var.project_name}-servers"
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "sg_servers_http" {
  security_group_id = aws_security_group.sg_servers.id
  type              = "ingress"
  protocol          = "tcp"
  to_port           = 80
  from_port         = 80
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "sg_servers_egress" {
  security_group_id = aws_security_group.sg_servers.id
  type              = "egress"
  protocol          = "-1"
  to_port           = 0
  from_port         = 0
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_instance" "server" {
  count                  = var.server_count
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_ids[count.index]
  vpc_security_group_ids = [aws_security_group.sg_servers.id]
  user_data              = <<-EOF
                #!/bin/bash
                echo "Hello, World ${count.index + 1}" > index.html
                python3 -m http.server 80 &
                EOF
  tags = {
    Name = "${var.project_name}-server-${count.index + 1}"
  }
}
