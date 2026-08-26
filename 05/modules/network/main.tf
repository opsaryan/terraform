data "aws_availability_zones" "available" {
    state = "available"
}

resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true
    tags = {
      Name = "${var.project_name}-${var.environment}-vpc"
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id
    tags = {
      Name = "${var.project_name}-${var.environment}-igw"
    }
}

resource "aws_subnet" "public" {
    count = length(var.public_subnet_cidrs)
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.public_subnet_cidrs[count.index]
    availability_zone = data.aws_availability_zones.available.names[count.index]
    map_public_ip_on_launch = true
    tags = {
      Name = "${var.project_name}-${var.environment}-public-${count.index + 1}"
    }
}

resource "aws_subnet" "private" {
    count = length(var.private_subnet_cidrs)
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.private_subnet_cidrs[count.index]
    availability_zone = data.aws_availability_zones.available.names[count.index]
    tags = {
      Name = "${var.project_name}-${var.environment}-private-${count.index + 1}"
    }
}

resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
    tags = {
      Name = "${var.project_name}-${var.environment}-public-rt"
    }
}

resource "aws_route_table_association" "public_rt_association" {
    count = length(aws_subnet.public)
    route_table_id = aws_route_table.public_rt.id
    subnet_id = aws_subnet.public[count.index].id
}
