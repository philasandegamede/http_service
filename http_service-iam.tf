resource "aws_iam_role" "http_service_iam-role" {
  name               = "ECS-execution-role"
  assume_role_policy = file("${path.module}/http-service-iam-role.json")
}

resource "aws_iam_role_policy" "iam-policy" {
  name   = "ECS-execution-role-policy"
  role   = aws_iam_role.http_service_iam-role.id
  policy = file("${path.module}/http-service-iam-policy.json")
}