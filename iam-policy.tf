resource "aws_iam_policy" "iam_enable_guardduty" {
  name        = "iam_enable-guardduty"
  path        = "/"
  description = "IAM Policy to enable GuardDuty"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "guardduty:*"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "iam:CreateServiceLinkedRole"
            ],
            "Resource": "arn:aws:iam::${var.aws_account_id}:role/aws-service-role/guardduty.amazonaws.com/AWSServiceRoleForAmazonGuardDuty",
            "Condition": {
                "StringLike": {
                    "iam:AWSServiceName": "guardduty.amazonaws.com"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "iam:PutRolePolicy",
                "iam:DeleteRolePolicy"
            ],
            "Resource": "arn:aws:iam::${var.aws_account_id}:role/aws-service-role/guardduty.amazonaws.com/AWSServiceRoleForAmazonGuardDuty"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "guardduty_security_bucket" {
  name        = "guardduty-security-bucket"
  path        = "/security/"
  description = "Allows full access to the contents of the guardduty bucket"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:ListAllMyBuckets",
      "Resource": "arn:aws:s3:::*"
    },
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": [
        "${aws_s3_bucket.guard_duty.arn}",
        "${aws_s3_bucket.guard_duty.arn}/*"
      ]
    }
  ]
}
EOF
}
resource "aws_iam_group" "guardduty" {
  name = "${var.group_name}"
  path = "/"
}

resource "aws_iam_group_policy_attachment" "enable" {
  group      = "${aws_iam_group.guardduty.name}"
  policy_arn = "${aws_iam_policy.iam_enable_guardduty.arn}"
}

resource "aws_iam_group_policy_attachment" "useS3bucket" {
  group      = "${aws_iam_group.guardduty.name}"
  policy_arn = "${aws_iam_policy.guardduty_security_bucket.arn}"
}

resource "aws_iam_group_policy_attachment" "access" {
  group      = "${aws_iam_group.guardduty.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonGuardDutyFullAccess"
}

resource "aws_iam_group_policy_attachment" "s3readonly" {
  group      = "${aws_iam_group.guardduty.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_group_membership" "guardduty" {
  name  = "guardduty-admin-members"
  group = "${aws_iam_group.guardduty.name}"
  users = "${var.users}"
}