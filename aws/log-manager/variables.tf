//Declare Variables
variable "aws_cred_file" {
  description = "AWS shared credentials file location."

}

variable "aws_profile" {
  description = "The AWS profile configured for credentials OR matching AWS_PROFILE environment variable."
}

variable "aws_region" {
  description = "AWS region for the deployment."
}

variable "force_delete_bucket" {
  description = "Specify if the bucket should be deleted and destroyed without error. Objects stored in the bucket are not recoverable."
  default     = true
}

variable "al_cloud_trail_role" {
  description = "Cloud trail Role"
}

variable "al_cloud_trail_policy" {
  description = "Cloud Trail Policy"
}

variable "al_external_id" {
  description = "This is your AlertLogic account ID."
}

variable "al_lm_aws_account_id" {
  description = "This is the AlertLogic Log collection AWS account ID."
}

//Create New Resources

variable "al_sns_topic_name" {
  description = "Name for Cloud Trail SNS topic"
}

variable "al_sqs_queue_name" {
  description = "Name for Cloud Trail SQS Queue name"
}

variable "al_cloud_trail_name" {
  description = "Cloud trail name for Alert Logic configuration, please leave value empty if you will be using an existing Cloud Trail resource"
}

//Use Existing Resources

variable "use_existing_sns_topic_arn" {
  description = "ARN of an existing CloudTrail topic to subscribe SQS to. Create the stack in the region where the SNS Topic exists"
}

variable "use_existing_sns_topic_name" {
  description = "Existing SNS topic name required, only if user doesn't intend to create new SNS for Cloud Trail deployment"
}

variable "use_existing_s3_bucket" {
  description = "Use existing s3 bucket if required"
}

variable "use_existing_s3_bucket_arn" {
  description = "ARN for existing s3 arn"
}

//Conditionals and Counts

variable "create_s3_bucket" {
  description = "creates s3 bucket, if set to TRUE"
  default     = false
}

variable "create_cloud_trail_sns_topic" {
  description = "if set to true, creates sns topic"
  default     = false
}

variable "cloud_trail_enabled" {
  description = "Set to false to prevent the module from creating any resources"
  default     = false
}
