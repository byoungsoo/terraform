output "cost_explorer_read_role_arn" {
  description = "Role ARN the cost exporter assumes (ASSUME_ROLE_ARN)"
  value       = aws_iam_role.cost_explorer_read.arn
}
