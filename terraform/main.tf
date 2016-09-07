provider "aws" {
  region  = "${var.aws_region}"
  profile = "default"
}

resource "aws_vpc" "gridlibrary" {
  cidr_block = "${var.vpc_cidr}"
}

###################################################
##                  Key Pair                     ##
###################################################

resource "aws_key_pair" "gridlibrary" {
  key_name = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

###################################################
##  Public subnet for ELB, Proxy, Bastion hosts  ##  
###################################################

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.gridlibrary.id}"
}

resource "aws_route" "internet_access" {
  route_table_id = "${aws_vpc.gridlibrary.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.default.id}"
}

resource "aws_subnet" "public" {
  vpc_id = "${aws_vpc.gridlibrary.id}"
  cidr_block = "${var.public_cidr}"
  availability_zone = "us-east-1b"
}


###################################################
##     Private subnet for all another stuff      ##  
###################################################

resource "aws_eip" "nat" {
      vpc = true
}

resource "aws_nat_gateway" "nat" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id = "${aws_subnet.public.id}"

  depends_on = ["aws_internet_gateway.default"]
}

resource "aws_subnet" "private" {
  vpc_id = "${aws_vpc.gridlibrary.id}"
  cidr_block = "${var.private_cidr}"
  availability_zone = "us-east-1b"
}

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.gridlibrary.id}"

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat.id}"
  }
}


###################################################
##               Security groups                 ##
###################################################

resource "aws_security_group" "bastion" {
  name = "bastion"
  description = "allow inbound ssh"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = "${aws_vpc.gridlibrary.id}"
}

resource "aws_security_group" "ping" {
  name = "ping"
  description = "allow icmp packets receiving"

  ingress {
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 8
    to_port = 0
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = "${aws_vpc.gridlibrary.id}"
}

###################################################
##                Instances                      ##  
###################################################

resource "aws_instance" "bastion" {
  ami = "${var.ubuntu_ami}"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.gridlibrary.key_name}"
  vpc_security_group_ids = ["${aws_security_group.bastion.id}"]
  subnet_id = "${aws_subnet.public.id}"
}

resource "aws_eip" "bastion" {
  instance = "${aws_instance.bastion.id}"
  vpc = true
}

resource "aws_instance" "test" {
  ami = "${var.ubuntu_ami}"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.gridlibrary.key_name}"
  vpc_security_group_ids = ["${aws_security_group.ping.id}"]
  subnet_id = "${aws_subnet.private.id}"
}

