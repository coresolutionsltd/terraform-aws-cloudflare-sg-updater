resource "aws_iam_role" "iam_for_lambda" {
  name               = "${var.name}-Role"
  tags               = var.tags
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "policy" {
  name        = "${var.name}-Policy"
  description = "Allows cloudflare ip updating lambda to change security groups"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
      ],
      "Resource": [
          "arn:aws:logs:*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
          "iam:GetRolePolicy",
          "iam:ListGroupPolicies",
          "ec2:DescribeSecurityGroups",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:RevokeSecurityGroupIngress"
      ],
      "Resource": [
          "*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "policy" {
  role       = aws_iam_role.iam_for_lambda.id
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_lambda_function" "lambda" {
  function_name    = var.name
  filename         = "${path.module}/lambda.zip"
  source_code_hash = filebase64sha256("${path.module}/lambda.zip")
  handler          = "cloudflare-sg-updater.lambda_handler"
  role             = aws_iam_role.iam_for_lambda.arn
  runtime          = "python3.6"
  timeout          = 60
  tags             = var.tags
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  count         = var.enabled ? 1 : 0
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.cloudflare-update-schedule.0.arn
}

resource "aws_cloudwatch_event_rule" "cloudflare-update-schedule" {
  count       = var.enabled ? 1 : 0
  name        = "cloudflare-sg-updater-schedule"
  description = "Update Security Groups with cloudflare IPs"

  schedule_expression = var.schedule
  tags                = var.tags
}

resource "aws_cloudwatch_event_target" "cloudflare-update-schedule" {
  count = var.enabled ? 1 : 0
  rule  = aws_cloudwatch_event_rule.cloudflare-update-schedule.0.name
  arn   = aws_lambda_function.lambda.arn
}
