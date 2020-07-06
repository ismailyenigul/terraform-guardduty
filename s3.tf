### Create  S3 bucket for GuardDuty Findigs
resource "aws_s3_bucket" "guardduty_security_bucket" {
	count     = var.create_s3_bucket ? 1 : 0
	bucket		    = var.guardduty_bucket_name
  region        = var.aws_region
  acl           = "private"
  lifecycle {
    prevent_destroy = false
  }
}
### IAM Policy to read/write to the GuardDuty Bucket
resource "aws_s3_bucket_object" "guardduty_iplist" {
	count      = length(aws_s3_bucket.guardduty_security_bucket)
  key        = "${var.guardduty_assets}/guardduty_iplist.txt"
  bucket     = aws_s3_bucket.guardduty_security_bucket[count.index].id
  source     = "${path.module}/template/guardduty_iplist.txt"
  content_type = "text/plain"
  etag       = md5(file("${path.module}/template/guardduty_iplist.txt"))
}
resource "aws_guardduty_ipset" "guardduty_iplist" {
	count     = var.enable_guardduty_ipset ? 1 : 0
  activate    = var.enable_guardduty_ipset
  detector_id = aws_guardduty_detector.guardduty.id
  format      = "TXT"
  location    = "https://s3.amazonaws.com/${aws_s3_bucket_object.guardduty_iplist[count.index].bucket}/${aws_s3_bucket_object.guardduty_iplist[count.index].key}"
  name        = "guardduty_iplist"
}
