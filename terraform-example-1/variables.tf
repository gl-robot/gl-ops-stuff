variable "public_key_path" {
  default = "~/.ssh/aws_rsa.pub"
}

variable "key_name" {
  description = "Desired name of AWS key pair"
  default     = "auth"
}

variable "private_key_path" {
  default = "~/.ssh/aws_rsa.pem"
}

variable "aws_region" {
  description = "AWS region to launch servers."
  default = "us-west-2"
}

# Ubuntu Precise 14.04 LTS (x64)
variable "aws_amis" {
  default = {
    us-west-2 = "ami-20be7540"
  }
}
