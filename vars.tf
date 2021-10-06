variable "aws_region" {
  default = "us-west-1"
}

variable "environment" {
  default = "sandbox"
}

variable "budget" {
  default = {
    budget_name         = "monthly-budget"
    budget_type         = "COST"
    limit_amount        = "500"
    limit_unit          = "USD"
    time_unit           = "MONTHLY"
    include_recurring   = true
    comparison_operator = "GREATER_THAN"
    threshold           = 80
    threshold_type      = "PERCENTAGE"
    notification_type   = "ACTUAL"
    email               = ["sysalerts@centrallogic.com"]
  }
}

variable "shutdown_lambda" {
  default = {
    type                        = "zip"
    source_file                 = "shutdown-lambda.py"
    output_path                 = "shutdown-lambda.zip"
    function_name               = "shutdown-instances-nightly"
    handler                     = "shutdown-lambda.lambda_handler"
    runtime                     = "python3.7"
    memory_size                 = "128"
    timeout                     = "300" #since lambda needs time to iterate over all aws regions, make this value above a min
    schedule                    = "cron(0 00 * * ? *)"
    cloudwatch_rule_name        = "shutdown-lambda-rule"
    cloudwatch_rule_description = "Shutdown instances everyday at 6pm CST"
  }
}