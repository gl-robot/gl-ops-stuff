provider "aws" {
  region  = "us-west-2"
  profile = "default"   
}

resource "aws_instance" "test" {
  ami = "ami-20be7540"
  instance_type = "t2.micro"
}

