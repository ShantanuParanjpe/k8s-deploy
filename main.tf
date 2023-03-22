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

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDQXmilKQeu1jYF2wj/8cZRYCncj0whNpud3xtsQcek1ZiAJwcaOsUM3S3gQ/QUyKEW/weJEybvcCzEFePbse/W6DQoZ3otubsXoSyfG++mlqmXwQtbsu9Nz8UhI1ExvcinlUeB5Mj//bqKDzjMjXGCedNCttlVefyjl0yRsPsuiXh4LkJH7+mtoCThRIxRFI0AIDW8yvAXt//ViJqj/bX1mHhHijA/P6f6qbaRr2fBVNvgBx0BhcgXSoCfNK6tq7JTS57x1s1GzekGTXCjO4n9AZy+L6C9yCmxrQ+pwz4ucNmMpK2IvGfSufTT9wjwlLNAmRVOjEZDLLqO8AhgW9ieo6je97ldbuc08XfXkhkxsylmHkQv9V74eLFEvBSeRAhovgpNOT8uoaFAijvt2MuR9rRv3KB8c0otp6JLWUWGGPGaAVYj8ubZsq1qgnb8WRguvqkSiLGP2XrccXnY/KZT91Yjnu9aUMVCnC1/aCZg8fTz76lHZx2cNRyeJ4zocgU= root@server"
  
}
