provider "aws" {
  region = "us-east-1"
}

resource "aws_eip" "eip-1" {
  vpc ="true"
}

 backend "s3" {
    bucket         	   = "mycomponents-tfstate"
    key              	   = "state/terraform.tfstate"
    region         	   = "us-east-1"
    encrypt        	   = true
 }
