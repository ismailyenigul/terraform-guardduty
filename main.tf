
## Enable GuardDuty
provider "aws" {
  region = var.aws_region
}
data "aws_caller_identity" "current" {}

resource "aws_guardduty_detector" "guardduty" {
  enable = true
}
