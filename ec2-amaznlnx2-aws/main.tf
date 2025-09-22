data "aws_ssm_parameter" "amazon_linux_2" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

resource "aws_vpc" "test_server_vpc" {
  cidr_block = "172.23.0.0/16"
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.test_server_vpc.id
  cidr_block = "172.23.0.0/24"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private" {
  vpc_id = aws_vpc.test_server_vpc.id
  cidr_block = "172.23.128.0/24"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.test_server_vpc.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.test_server_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "test_server_sg" {
  name = "test_server_sg"
  description = "Allow SSH"
  vpc_id = aws_vpc.test_server_vpc.id

  ingress {
    description = "SSH"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_vpc_security_group_ingress_rule" "test_server_web_access" {
  security_group_id = aws_security_group.test_server_sg.id

  cidr_ipv4 = "0.0.0.0/0"
  from_port = 0
  to_port = 80
  ip_protocol = "tcp"
}

resource "aws_instance" "test_server" {
  count = 3
  ami = data.aws_ssm_parameter.amazon_linux_2.value
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.test_server_sg.id]
  key_name = "EKS_Admin"
  tags = {
    Name = "test_server-${count.index}"
    Source = "terraform"
  }
}

