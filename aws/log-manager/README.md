# Cloud Trail Log Collection - Terraform

This template is intended to allow Alert Logic customer to provision and configure resources required for AWS Cloud Trail log collection. This provides Alert Logic with the required access to collect and analyse Cloud Trail logs on the customer account

* Configuration Requirements/Resources
    - Cloud Trail Resource
    - S3 Bucket
    - SNS Topic
    - SQS Queue
    - SNS Topic Subscription

There are options to use existing AWS resources or create new resource to complete the task as required

### Variables

Variables are declared and assigned in variables.tf and vars.tfvars as follows

#### variables.tf

```h
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
use_existing_s3_bucket = "insert_existing_s3_bucket_name_here" // Assign value if you intend to use existing s3 use_existing
use_existing_s3_bucket_arn = "insert_existing_s3_bucket_arn_here" // Provide Role ARN for existing s3 bucket
```
#### Apply changes to vars.tfvars for conditionals and counts

```h
variable "create_s3_bucket" {
  description = "creates s3 bucket, if set to TRUE"
  default     = false
}

variable "create_cloud_trail_sns_topic" {
  description = "if set to true, creates sns topic"
  default     = false
}

variable "cloud_trail_enabled" {
  description = "Set to false to prevent module from create new Cloud Trail resource"
  default     = false
}
```

## How to Use
#### Please Note: The following template only compatible with terraform 0.11.14
1. Clone repository to workspace
2. Change and assign variables as required
3. Run the following Terraform command in a Bash shell

   ```
      terraform init
      terraform fmt
      terraform plan -var-file=vars.tfvars
      terraform apply -var-file=vars.tfvars
   ```
