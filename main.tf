provider "aws" {
  region = "us-east-1"
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
  ingress {
<<<<<<< HEAD
    from_port = 0
=======
    from_port = 22
>>>>>>> 6c5c08fb706a145c47a8b7d54aea59ea58b4ca93
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.example.id
}


resource "aws_instance" "instance-1" {
<<<<<<< HEAD
  ami           = "ami-026ebd4cfe2c043b2"
=======
  ami           = "ami-067a8829f9ae24c1c"
>>>>>>> 6c5c08fb706a145c47a8b7d54aea59ea58b4ca93
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.example.id]
  subnet_id              = aws_subnet.example-subnet.id
  associate_public_ip_address = "true"
  key_name = "aws-key" 
}

resource "aws_instance" "instance-2" {
<<<<<<< HEAD
  ami           = "ami-026ebd4cfe2c043b2"
=======
  ami           = "ami-067a8829f9ae24c1c"
>>>>>>> 6c5c08fb706a145c47a8b7d54aea59ea58b4ca93
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.example.id]
  subnet_id              = aws_subnet.example-subnet.id
  associate_public_ip_address = "true"
  key_name = "aws-key"
}
