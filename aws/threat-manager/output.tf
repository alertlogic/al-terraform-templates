// Outputs
output "tmc_public_ip" {
	value = "${aws_eip.tmc.*.public_ip}"
}

output "tmc_private_ip" {
	value = "${aws_instance.tmc.*.private_ip}"
}

output "tmc_sg_id" {
	value = "${aws_security_group.tmc_sg.id}"
}
