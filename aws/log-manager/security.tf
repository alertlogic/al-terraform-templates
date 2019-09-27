//Create Alert Logic Role
resource "aws_iam_role" "al_cloudtrail_iam_role" {
  name = "${var.al_cloud_trail_role}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": "arn:aws:iam::${var.al_lm_aws_account_id}:root"
      },
      "Condition": {
        "StringEquals": {"sts:ExternalId": "${var.al_external_id}"}
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

//Create Alert Logic Policy
resource "aws_iam_policy" "al_cloudtrail_iam_policy" {
  name = "${var.al_cloud_trail_policy}"
  path = "/"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "S3AuditLoggingAndLogCollection1",
      "Resource": "${coalesce(join("", aws_s3_bucket.al_cloudtrail_s3_bucket.*.arn), var.use_existing_s3_bucket_arn)}/*",
      "Effect": "Allow",
      "Action": [
          "s3:GetObject"
        ]
      },
    {
      "Sid": "S3AuditLoggingAndLogCollection2",
      "Resource":  "${coalesce(join("", aws_s3_bucket.al_cloudtrail_s3_bucket.*.arn), var.use_existing_s3_bucket_arn)}/*",
      "Effect": "Allow",
      "Action": [
          "s3:ListBucket"
      ]
    },
    {
      "Sid": "ReceiveAndDeleteMessageFromSqsQueue",
      "Resource":  "${aws_sqs_queue.al_cloudtrail_sqs_queue.arn}",
      "Effect": "Allow",
      "Action": [
          "sqs:GetQueueUrl",
          "sqs:Receivemessage",
          "sqs:DeleteMessage"
      ]
    }
  ]
}
EOF
}

//Cloud Trail SQS Policy
resource "aws_sqs_queue_policy" "al_cloudtrail_sqs_policy" {
  queue_url = "${aws_sqs_queue.al_cloudtrail_sqs_queue.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "SQSDefaultPolicy",
  "Statement": [
    {
      "Sid": "Allow-SendMessage-To-Queue-From-SNS-Topic",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:SendMessage",
      "Resource": "${aws_sqs_queue.al_cloudtrail_sqs_queue.arn}",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${coalesce(join("", aws_sns_topic.al_cloudtrail_sns_topic.*.arn), var.use_existing_sns_topic_arn)}"
        }
      }
    }
  ]
}
POLICY
}

//Cloud Trail SNS Topic Policy
resource "aws_sns_topic_policy" "al_cloudtrail_sns_topic_policy" {
  arn = "${coalesce(join("", aws_sns_topic.al_cloudtrail_sns_topic.*.arn), var.use_existing_sns_topic_arn)}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
    {
      "Sid": "__default_statement_ID",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": [
        "SNS:Subscribe",
        "SNS:ListSubscriptionsByTopic",
        "SNS:DeleteTopic",
        "SNS:GetTopicAttributes",
        "SNS:Publish",
        "SNS:RemovePermission",
        "SNS:AddPermission",
        "SNS:Receive",
        "SNS:SetTopicAttributes"
      ],
      "Resource": "${coalesce(join("", aws_sns_topic.al_cloudtrail_sns_topic.*.arn), var.use_existing_sns_topic_arn)}",
      "Condition": {
        "StringEquals": {
          "AWS:SourceOwner": "${data.aws_caller_identity.current.account_id}"
        }
      }
    },
    {
        "Sid": "AWSCloudTrailSNSPolicy20131101FromCloudTrailMainTF",
        "Effect": "Allow",
        "Principal": {"Service": "cloudtrail.amazonaws.com"},
        "Action": "SNS:Publish",
        "Resource": "${coalesce(join("", aws_sns_topic.al_cloudtrail_sns_topic.*.arn), var.use_existing_sns_topic_arn)}"
    }]
}
EOF
}

// Cloudtrail S3 bucket policy
resource "aws_s3_bucket_policy" "al_cloudtrail_s3_bucket_policy" {
  bucket = "${coalesce(join("", aws_s3_bucket.al_cloudtrail_s3_bucket.*.id), var.use_existing_s3_bucket)}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "${coalesce(join("", aws_s3_bucket.al_cloudtrail_s3_bucket.*.arn), var.use_existing_s3_bucket_arn)}"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "${coalesce(join("", aws_s3_bucket.al_cloudtrail_s3_bucket.*.arn), var.use_existing_s3_bucket_arn)}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
EOF
}

// Attach IAM policy to IAM role
resource "aws_iam_role_policy_attachment" "al_cloudtrail_iam_role_policy_attachment" {
  role       = "${aws_iam_role.al_cloudtrail_iam_role.name}"
  policy_arn = "${aws_iam_policy.al_cloudtrail_iam_policy.arn}"
}
