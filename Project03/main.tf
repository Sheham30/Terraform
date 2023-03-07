# VPC
resource "aws_vpc" "sh_vpc" {
  cidr_block           = "10.123.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true # not necessary

  tags = {
    name = "dev"
  }
}

# Subnet
resource "aws_subnet" "sh_public_subnet" {
  vpc_id                  = aws_vpc.sh_vpc.id
  cidr_block              = "10.123.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    name = "dev-public"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "sh_internet_gateway" {
  vpc_id = aws_vpc.sh_vpc.id

  tags = {
    Name = "dev-igw"
  }
}

# Route Table
resource "aws_route_table" "sh_public_rt" {
  vpc_id = aws_vpc.sh_vpc.id

  tags = {
    Name = "dev_public_rt"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.sh_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.sh_internet_gateway.id
}

# Route Table Association
# (To bridge the gap between subnet and oute table)
resource "aws_route_table_association" "sh_public_assoc" {
  subnet_id      = aws_subnet.sh_public_subnet.id
  route_table_id = aws_route_table.sh_public_rt.id
}

# Security Group
resource "aws_security_group" "sh_sg" {
  name        = "dev_sg"
  description = "dev security group"
  vpc_id      = aws_vpc.sh_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["194.32.120.14/32"]
    # ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

# Key Pair; We will use "file" function here instead of whole key
resource "aws_key_pair" "sh_auth" {
  key_name   = "sh_key"
  public_key = file("~/.ssh/shkey.pub")
}

# EC2 Instance
resource "aws_instance" "dev_node" {
  instance_type = "t2.micro"
  ami = data.aws_ami.sh_ami.id
  key_name = aws_key_pair.sh_auth.id
  vpc_security_group_ids = [aws_security_group.sh_sg.id]
  subnet_id = aws_subnet.sh_public_subnet.id
  user_data = file("userdata.tpl")

  root_block_device {
    volume_size = 10
  }

  tags = {
    Name = "dev-node"
  }

}
