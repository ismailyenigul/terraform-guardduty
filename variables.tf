
variable "aws_region" {
    description = "AWS Region where Guardduty will be enabled"
    default = "eu-west-1"
}
variable "create_sns_topic" {
    description = "Whether SNS topic will be created"
    type        = bool
    default     = true
}
variable "create_s3_bucket" {
    description = "Whether S3 bucket for Guardduty Logs will be created"
    type        = bool
    default     = true
}
variable "enable_guardduty_ipset" {
    description = "Whether Guardduty IPSet will be enabled"
    type        = bool
    default     = true
}
variable "manage_guardduty_role" {
    description = "Whether Policies and Roles Permitting access to GuardDuty and S3 will be created"
    type        = bool
    default     = true
}
variable "guardduty_assets" {
      default = "guardduty"
			description =  "bucket folder in the s3 for IPlist"
}
variable "sns_topic_name" {
    description = "SNS topic where GuardDuty Alerts will be sent"
    type        = string
    default     = "GuardDuty_Notifications"
}
variable "sns_delivery_policy" {
    description = "The SNS delivery policy"
    type        = string
    default     = "null"
}
variable "guardduty_role_name" {
    description = "IAM Role which permits enabling GuardDuty"
    default = "GuardDuty_IAM_Role"
}

variable "guardduty_bucket_name" {
    description = "Guardduty S3 bucket to import iplist"
    default = "my-guardduty-bucket-name"
}
variable "guardduty_notification_endpoint" {
    description = "Endpoint for the GuardDuty SNS notifications"
		default = "https://www.example.com/url/to/endpoint"
}
variable "guardduty_subscription_protocol" {
    description = "Protocol for the GuardDuty SNS notifications"
		default = "https"
}

variable "endpoint_auto_confirms" {
	  description = "Endpoint auto confirmation value"
		default = true
}
