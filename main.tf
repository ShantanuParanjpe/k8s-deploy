provider "aws" {
  region = "us-east-2"
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_vpc" "example" {
  cidr_block = "192.168.0.0/24"
}

resource "aws_subnet" "example-subnet" {
  vpc_id     = aws_vpc.example.id
  cidr_block = "192.168.1.0/25"
}

resource "aws_security_group" "example" {
  name = "example"
  vpc_id   = aws_vpc.example.id 
  ingress {
    from_port = 0
    to_port   = 65535
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "instance-1" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.example.id]
  subnet_id              = aws_subnet.example-subnet.id

  tags = {
    Name = "instance-1"
  }
}

resource "aws_instance" "instance-2" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.example.id]
  subnet_id              = aws_subnet.example-subnet.id

  tags = {
    Name = "instance-2"
  }
}


