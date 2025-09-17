provider "aws" {
  region = var.ec2_region
}

resource "aws_vpc" "bdtvpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = false
  tags = {
    Name = "Brad-Does-Tech-VPC"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.bdtvpc.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "Brad-Does-Tech-Subnet-Public"
  }
}

resource "aws_route_table" "bdtrt" {
  vpc_id = aws_vpc.bdtvpc.id
  tags = {
    Name = "Brad-Does-Tech-Route-Table"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.bdtrt.id
}

resource "aws_internet_gateway" "bdtigw" {
  vpc_id = aws_vpc.bdtvpc.id
  tags = {
    Name = "Brad-Does-Tech-Internet-Gateway"
  }
}

resource "aws_route" "internet-route" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.bdtrt.id
  gateway_id             = aws_internet_gateway.bdtigw.id
}

resource "aws_security_group" "bdtsg" {
  name        = "Brad-Does-Tech-SG"
  description = "Allow inbound traffic"
  tags = {
    Name = "Brad-Does-Tech-Inbound-SG"
  }
  vpc_id = aws_vpc.bdtvpc.id
  ingress {
    description = "SSH"
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTPS"
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    to_port     = "0"
  }
}

data "aws_ami" "rhelami" {
  most_recent = true
  owners      = ["309956199498"]

  filter {
    name   = "name"
    values = ["RHEL-10*-x86_64-*"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_instance" "tfservers" {
  ami                         = data.aws_ami.rhelami.id
  count                       = var.number_of_instances
  instance_type               = var.instance_type
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.bdtsg.id]
  key_name                    = var.instance_key
  tags = {
    Name        = "${var.instance_name}${count.index}.redhatbrad.com"
    Environment = var.instance_environment
    Region      = var.ec2_region
  }
}

resource "aws_route53_record" "server_dns" {
  count   = var.number_of_instances
  zone_id = "${var.hosted_zone_id}"
  name    = "${var.instance_name}${count.index}.${var.instance_domain_name}"
  type    = "A"
  ttl     = 300
  records = [aws_instance.tfservers[count.index].public_ip]
}
