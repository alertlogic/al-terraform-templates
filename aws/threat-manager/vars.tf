# Specify the provider and access details below

provider "aws" {
  region     = "${var.aws_region}"
  access_key = "${var.aws_access_key_id}"
  secret_key = "${var.aws_secret_access_key}"
  version    = "~> 1.6"
}

variable "aws_region" {
  description = "The AWS region to deploy the appliance in."
}

variable "aws_access_key_id" {
  description = "The user access key for authentication."
}

variable "aws_secret_access_key" {
  description = "The user secret access key for authentication."
}

# Set main variables

variable "vpc_id" {
  description = "VPC into which Threat Manager will be deployed (Must have available EIPs)."
}

variable "subnet_id" {
  description = "ID of a DMZ subnet, with a default route to an IGW, into which Threat Manager will be deployed."
}

variable "instance_type" {
  description = "EC2 Instance Type Threat Manager will be spun up as (Supported: c4.large, c4.xlarge, c4.2xlarge, c5.large, c5.xlarge, c5.2xlarge)."
}

variable "tag_name" {
  description = "Provide a tag name for your Threat Manager instance."
}

variable "tag_env" {
  description = "Provide a tag env for your Threat Manager instance."
  default     = "alertlogic"
}

variable "claim_cidr" {
  description = "CIDR netblock which will be submitting the web form that the appliance serves for claiming over port 80 (This rule can be removed after the appliance has been claimed)."
}

variable "monitoring_cidr" {
  description = "CIDR netblock to be monitored (Where agents will be installed)."
}

variable "create_eip" {
  description = "Set value to 1(true) if you want to deploy it on public subnet, otherwise set to 0(false)"
}

variable "alertlogic_enabled" {
  description = "Set value to 1(true) if you want to deploy alertlogic tmc instance, otherwise set to 0(false)"
  default     = "1"
}

# Latest AMI as per Mar 2018, contact AlertLogic (support@alertlogic.com) if you want to see the latest AMI per region
# Tag to ver: P13
variable "aws_amis" {
  default = {
    ap-south-1     = "ami-944916fb"
    eu-west-3      = "ami-2d66d050"
    eu-west-2      = "ami-c66480a1"
    eu-west-1      = "ami-c57336bc"
    ap-northeast-2 = "ami-e768c589"
    ap-northeast-1 = "ami-f07e3896"
    sa-east-1      = "ami-72115a1e"
    ca-central-1   = "ami-6d880f09"
    ap-southeast-1 = "ami-1c1e5560"
    ap-southeast-2 = "ami-3edd1b5c"
    eu-central-1   = "ami-aa92ffc5"
    us-east-1      = "ami-5934df24"
    us-east-2      = "ami-e5fdca80"
    us-west-1      = "ami-87e6ede7"
    us-west-2      = "ami-5b9e1623"
    us-gov-west-1  = "ami-89df5ce8"
  }
}
