provider "aws" {
  region  = "${var.aws_region}"
  profile = "default"
}

resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"
}

###################################################
##  Public subnet for ELB, Proxy, Bastion hosts  ##  
###################################################

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
}

resource "aws_route" "internet_access" {
  route_table_id = "${aws_vpc.default.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.default.id}"
}

resource "aws_subnet" "public" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "10.0.0.0/24"
}


###################################################
##     Private subnet for all another stuff      ##  
###################################################

#
# TODO
#

###################################################
##                Instances                      ##  
###################################################

