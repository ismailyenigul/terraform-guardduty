
resource "aws_sns_topic" "guardduty_sns_topic" {
  count   = var.create_sns_topic ? 1 : 0
  name    = var.sns_topic_name
  delivery_policy = file("${path.module}/template/sns_delivery_policy.json")
}

resource "aws_sns_topic_subscription" "guardguty_notifications" {
  count     = var.create_sns_topic ? 1 : 0
  topic_arn = aws_sns_topic.guardduty_sns_topic[count.index].arn
  protocol  = var.guardduty_subscription_protocol
  endpoint  = var.guardduty_notification_endpoint
	endpoint_auto_confirms = var.endpoint_auto_confirms
}
