# terraform-guardduty

Terraform module to enable the AWS GuardDuty service. The module creates the following resources:

- Enable AWS GuardDuty
- Create an S3 bucket for GuardDuty Assets 
- Set up CloudWatch to capture GuardDuty Events
- Enable GuardDuty IPList (optional)
- Create AWS Policies to manage GuardDuty and attach them to a Role (optional)
- Create an SNS topic for GuardDuty and manage subscription (optional)



## Usage

The following requirements need to be met in order to use the module:

- Valid AWS credentials
- Terraform installation

Sample usage:

```hcl
module "terraform-guardduty" {
  source = "../../modules/terraform-guardduty"
  guardduty_enable_ipset = "true"
  create_sns_topic = "true"
  sns_topic_name = <TOPIC NAME>
  manage_guardduty_role = "true"
  guardduty_role_name  "GuardDuty_Manager"
  guardduty_subscription_protocol = "sms"
  guardduty_notification_endpoint = <Notificaion endpoint>
  create_s3_bucket = true/false
  enable_guardduty_ipset = true/false
  guardduty_bucket_name = "my-guard-duty-bucket-name"


}
```

## Variables
The following variables can be configured:

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws\_region | AWS Region Name | string | "eu-west-1" | no |
| aws\_account\_id | AWS Account ID | string | n/a | yes |
| create\_sns\_topic | Whether a new SNS topic for GuardDuty Events should be configured | string | "true"  | no |
| sns\_topic\_name | Name of the SNS topic where AWS GuardDuty findings will be sent | string | "GuardDuty_Notifications" | no |
| manage\_guardduty\_role | Whether dedicated Role & Policies to manage GuardDuty will be created| string | "true"  | no |
| guardduty\_role\_name | Name of the Role which will manage the GuardDuty service | string | "GuardDuty_enable_role"  | no |
| guardduty\_bucket\_prefix | Name Prefix for the S3 bucket for GuardDuty assets | string | "GuardDuty" | no |
| guardduty\_enable\_ipset | Whether IPSet will be enabled for GuardDuty | string | "false"  | no |
| guardduty\_notification\_endpoint | SNS Notification Endpoint | string | n/a  | yes |
| guardduty\_subscription\_protocol | SNS Subscription Protocol (http/https/sms/sqs/application/lambda) | string | n/a  | yes |

```hcl
aws_region
aws_account_id
create_sns_topic
sns_topic_name 
manage_guardduty_role
guardduty_notification_recipient
guardduty_subscription_protocol
guardduty_role_name
guardduty_enable_ipset
guardduty_bucket_prefix

```

