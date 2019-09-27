/*
# -------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
#
# -------------------------------------------------------------------------------------------------------------------
*/

aws_cred_file = "~/.aws/credentials" // The AWS profile configured for credentialse

aws_profile = "default" // An AWS credentials file to specify your credentials

aws_region = "xx-xxxx-xx" // The AWS region to deploy the Cloud Trail

al_cloud_trail_role = "al-cloudtrail-role" // Cloud Trail Role Name

al_cloud_trail_policy = "al-cloud-trail-policy" //Cloud Trail Policy Name

al_external_id = "xxxxxx" // Your AlertLogic Account ID

al_lm_aws_account_id = "xxxxxxxx" // Alert Logic Log Manager AWS accound ID

al_sns_topic_name = "alert-logic-sns-topic" // Required to create SNS Topic, please ignore if you intend use an existing Topic

al_sqs_queue_name = "al-cloudtrail-sqs-queue" // Required to create SQS queue, please ignore if you intend use an existing SQS Queue

al_cloud_trail_name = "alertlogic-cloud-trail" // Required to create Cloud trail

use_existing_sns_topic_arn = "insert_existing_sns_topic_arn_here" // Assign value if you intend to use existing SNS Topic Role ARN

use_existing_sns_topic_name = "insert_existing_sns_topic_name_here" // Assign value if you intend to use existing SNS Topic

use_existing_s3_bucket = "insert_existing_s3_bucket_name_here" // Assign value for existing s3 use_existing

use_existing_s3_bucket_arn = "insert_existing_s3_bucket_arn_here" // Role ARN for existing s3 bucket
