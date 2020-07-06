resource "aws_cloudwatch_event_rule" "guardduty-finding-events" {
  name          = "guardduty-finding-events"
  description   = "Capture AWS GuardDuty event findings"
  event_pattern = file("${path.module}/template/guardduty-event-pattern.json")
}

resource "aws_cloudwatch_event_target" "sns" {
  count     = var.create_sns_topic ? 1 : 0
  rule      = aws_cloudwatch_event_rule.guardduty-finding-events.name
  target_id = "send-to-sns"
	# arn       = aws_sns_topic.guardduty_sns_topic.arn
	arn       = aws_sns_topic.guardduty_sns_topic[count.index].arn


  input_transformer {
    input_paths = {
      title = "$.detail.title"
    }

    input_template = "\"GuardDuty finding: <title>\""
  }
}
