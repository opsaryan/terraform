data "aws_ami" "ubuntu" {
    most_recent = true
    owners = ["099720109477"]

    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
    }
}

resource "aws_security_group" "sg_servers" {
    name = "${var.project_name}-${var.environment}-servers"
    vpc_id = var.vpc_id
    tags = {
      Name = "${var.project_name}-${var.environment}-servers-sg"
    }
}

resource "aws_security_group_rule" "sg_servers_http" {
    security_group_id = aws_security_group.sg_servers.id
    type = "ingress"
    protocol = "tcp"
    to_port = 80
    from_port = 80
    source_security_group_id = var.lb_security_group_id
}

resource "aws_security_group_rule" "sg_servers_egress" {
    security_group_id = aws_security_group.sg_servers.id
    type = "egress"
    protocol = "-1"
    to_port = 0
    from_port = 0
    cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_instance" "server" {
    count = var.server_count
    ami = data.aws_ami.ubuntu.id
    instance_type = var.instance_type
    subnet_id = var.subnet_ids[count.index % length(var.subnet_ids)]
    vpc_security_group_ids = [ aws_security_group.sg_servers.id ]
    user_data = <<-EOF
                #!/bin/bash
                echo "Hello from ${var.environment} server ${count.index + 1}" > index.html
                python3 -m http.server 80 &
                EOF
    tags = {
      Name = "${var.project_name}-${var.environment}-server-${count.index + 1}"
    }
}
