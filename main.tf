provider "aws" {
  region = "us-east-2"
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "example-subnet" {
  vpc_id     = aws_vpc.example.id
  cidr_block = "10.0.1.0/24"
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

resource "aws_key_pair" "TF_key" {
  key_name = "TF_key"
  public_key = tls_private_key.rsa.public_key_openssh
  provisioner "local-exec" {
    command = <<-EOT
      echo '${tls_private_key.rsa.private_key_pem}' > aws_keys_pairs.pem
      chmod 400 aws_keys_pairs.pem
    EOT
  }
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "aws_instance" "instance-1" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.example.id]
  subnet_id              = aws_subnet.example-subnet.id
  associate_public_ip_address = "true"
  key_name = "TF_key"
  tags = {
    Name = "instance-1"
  }
}

resource "aws_instance" "instance-2" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.example.id]
  subnet_id              = aws_subnet.example-subnet.id
  associate_public_ip_address = "true"
  key_name = "TF_key"
  tags = {
    Name = "instance-2"
  }
}

