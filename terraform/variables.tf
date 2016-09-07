variable "aws_region" {
  default = "us-east-1"
}

variable "ubuntu_ami" {
  default = "ami-d90d92ce"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_cidr" {
  default = "10.0.1.0/24"
}

variable "private_cidr" {
  default = "10.0.2.0/24"
}

variable "key_name" {
  default = "gridlibrary"
}

variable "public_key_path" {
  default = "~/.ssh/gridlibrary.pub"
}
