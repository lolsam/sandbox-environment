resource "aws_iam_role" "role-lambda" {
  name               = "${var.environment}-lambda-role"
  assume_role_policy = file("./lambda/lambda-ec2-role.json")
}

resource "aws_iam_policy" "lambda-service-policy" {
  name   = "${var.environment}-lambda-service-policy"
  policy = file("./lambda/lambda-ec2-policy.json")
}

resource "aws_iam_role_policy_attachment" "attach-lambda-role" {
  role       = aws_iam_role.role-lambda.name
  policy_arn = aws_iam_policy.lambda-service-policy.arn
}

#================================================================

data "archive_file" "zip" {
  type        = var.shutdown_lambda.type
  source_file = var.shutdown_lambda.source_file
  output_path = var.shutdown_lambda.output_path
}

resource "aws_lambda_function" "shutdown-lambda" {
  function_name = var.shutdown_lambda.function_name

  filename         = data.archive_file.zip.output_path
  source_code_hash = data.archive_file.zip.output_base64sha256

  role        = aws_iam_role.role-lambda.arn
  handler     = var.shutdown_lambda.handler #this is filename of the lambda code followed by handler in the code
  runtime     = var.shutdown_lambda.runtime
  memory_size = var.shutdown_lambda.memory_size
  timeout     = var.shutdown_lambda.timeout
}

#--------------------------------------------------------------------

resource "aws_cloudwatch_event_rule" "everyday" {
  name                = var.shutdown_lambda.cloudwatch_rule_name
  description         = var.shutdown_lambda.cloudwatch_rule_description
  schedule_expression = var.shutdown_lambda.schedule
}

resource "aws_cloudwatch_event_target" "everyday" {
  rule      = aws_cloudwatch_event_rule.everyday.name
  target_id = var.shutdown_lambda.function_name
  arn       = aws_lambda_function.shutdown-lambda.arn
}
