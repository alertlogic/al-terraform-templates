//Outputs
output "alertlogic_cloudtrail_sqs_queue_name" {
  value = "${aws_sqs_queue.al_cloudtrail_sqs_queue.name}"
}

output "alertlogic_cloudtrail_iam_role_arn" {
  value = "${aws_iam_role.al_cloudtrail_iam_role.arn}"
}

output "alertlogic_external_id" {
  value = "${var.al_external_id}"
}
