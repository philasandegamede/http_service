resource "aws_sqs_queue" "terraform_queue" {
  name = "http_service_queue"
  tags = {
    Name = "http-service-queue"
  }
}

resource "aws_sns_topic" "http_service_topic" {
  name = "http-service-topic"
}

resource "aws_sns_topic_subscription" "email_sub" {
  topic_arn = aws_sns_topic.http_service_topic.arn
  protocol  = "email"
  endpoint  = "philasande@asandegamede.com"
}