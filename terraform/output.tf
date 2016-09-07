output "nat_eip" {
  value = "${aws_eip.nat.public_ip}"
}

output "aws_eip" {
  value = "${aws_eip.bastion.public_ip}"
}
