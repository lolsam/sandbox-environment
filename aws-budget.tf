resource "aws_budgets_budget" "monthly" {
  name         = "${var.environment}-${var.budget.budget_name}"
  budget_type  = var.budget.budget_type
  limit_amount = var.budget.limit_amount
  limit_unit   = var.budget.limit_unit
  time_unit    = var.budget.time_unit

  cost_types {
    include_recurring = var.budget.include_recurring

  }

  notification {
    comparison_operator        = var.budget.comparison_operator
    threshold                  = var.budget.threshold
    threshold_type             = var.budget.threshold_type
    notification_type          = var.budget.notification_type
    subscriber_email_addresses = var.budget.email
  }
}