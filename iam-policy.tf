### IAM Policy needed to enable GuardDuty

data "template_file" "iam_enable_guardduty" {
  template = "${file("${path.module}/template/guardduty_manage_policy.json")}"
	vars  = {
		aws_account_id =  data.aws_caller_identity.current.account_id
  }
}

resource "aws_iam_policy" "iam_enable_guardduty" {
	count       = var.manage_guardduty_role ? 1 : 0
  name        = "IAM-enable-guardduty"
  path        = "/"
  description = "IAM Permissions to enable GuardDuty"
	policy = data.template_file.iam_enable_guardduty.rendered
}
### IAM Policy to manage the Guardduty Security Bucket

data "template_file" "guardduty_security_bucket" {
	 count =  length(aws_s3_bucket.guardduty_security_bucket)
  template = "${file("${path.module}/template/s3_bucket_policy.json")}"
	vars  = {
		#aws_account_id = var.aws_account_id
		aws_account_id =  data.aws_caller_identity.current.account_id
		bucket_arn = aws_s3_bucket.guardduty_security_bucket[count.index].arn
  }
}


resource "aws_iam_policy" "guardduty_security_bucket" {
	#count       = var.manage_guardduty_role ? 1 : 0
	count =  length(aws_s3_bucket.guardduty_security_bucket)
	#count      = length(aws_s3_bucket.guardduty_security_bucket,var.manage_guardduty_role])
  name        = "guardduty-security-bucket"
  description = "Allows full access to the contents of the guardduty bucket"
  policy = data.template_file.guardduty_security_bucket[count.index].rendered
}

data "aws_iam_policy_document" "guardduty-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["guardduty.amazonaws.com"]
    }
  }
}
### AWS Role with permissions to manage Guardduty
resource "aws_iam_role" "guardduty_manage_role" {
  count       = var.manage_guardduty_role ? 1 : 0
  name        = "guardduty_manage_role"
  assume_role_policy = data.aws_iam_policy_document.guardduty-assume-role-policy.json
}

resource "aws_iam_role_policy_attachment" "useS3bucket" {
  count       = var.manage_guardduty_role ? 1 : 0
  role        = aws_iam_role.guardduty_manage_role[count.index].name
  policy_arn  = aws_iam_policy.guardduty_security_bucket[count.index].arn
	#policy_arn  = aws_iam_role.guardduty_manage_role[count.index].arn
}
resource "aws_iam_role_policy_attachment" "guardduty-policy-attach" {
  count       = var.manage_guardduty_role ? 1 : 0
  role        = aws_iam_role.guardduty_manage_role[count.index].name
  policy_arn  = aws_iam_policy.iam_enable_guardduty[count.index].arn
}
### IAM Role for Lambda
resource "aws_iam_role" "lambda_exec_role" {
  count       = var.manage_guardduty_role ? 1 : 0
  name        = "lambda_exec_role"
  assume_role_policy = file("${path.module}/template/lambda_assumerole_policy.json")
} 
 
