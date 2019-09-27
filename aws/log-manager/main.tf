// Specify the provider and alternative access details below if needed
provider "aws" {
  profile                 = "${var.aws_profile}"
  shared_credentials_file = "${var.aws_cred_file}"
  region                  = "${var.aws_region}"
  version                 = ">= 1.6"
}

data "aws_caller_identity" "current" {}

//Cloud Trail SQS Queue
resource "aws_sqs_queue" "al_cloudtrail_sqs_queue" {
  name = "${var.al_sqs_queue_name}"
}

//Cloud Trail SNS Topic
resource "aws_sns_topic" "al_cloudtrail_sns_topic" {
  count = "${var.create_cloud_trail_sns_topic ? 1 : 0}"
  name  = "${var.al_sns_topic_name}"
}

//Enable Cloud Trail
resource "aws_cloudtrail" "alert_logic_cloudtrail" {
  count                         = "${var.cloud_trail_enabled ? 1 : 0}"
  name                          = "${var.al_cloud_trail_name}"
  s3_bucket_name                = "${coalesce(join("", aws_s3_bucket.al_cloudtrail_s3_bucket.*.id), var.use_existing_s3_bucket)}"
  include_global_service_events = true
  is_multi_region_trail         = true
  sns_topic_name                = "${coalesce(join("",aws_sns_topic.al_cloudtrail_sns_topic.*.name), var.use_existing_sns_topic_name)}"
  depends_on                    = ["aws_s3_bucket_policy.al_cloudtrail_s3_bucket_policy", "aws_sns_topic_policy.al_cloudtrail_sns_topic_policy"]
}

//Cloudtrail s3 bucket
resource "aws_s3_bucket" "al_cloudtrail_s3_bucket" {
  count         = "${var.create_s3_bucket ? 1 : 0}"
  bucket        = "alertlogic-cloudtrail-${data.aws_caller_identity.current.account_id}"
  force_destroy = "${var.force_delete_bucket}"
  acl           = "private"
}

// Subscribe Cloudtrail SQS to CloudTrail SNS
resource "aws_sns_topic_subscription" "al_cloudtrail_sqs_subscribe" {
  topic_arn              = "${coalesce(join("", aws_sns_topic.al_cloudtrail_sns_topic.*.arn), var.use_existing_sns_topic_arn)}"
  protocol               = "sqs"
  endpoint               = "${aws_sqs_queue.al_cloudtrail_sqs_queue.arn}"
  endpoint_auto_confirms = true
  depends_on             = ["aws_sns_topic.al_cloudtrail_sns_topic", "aws_sqs_queue.al_cloudtrail_sqs_queue"]
}
