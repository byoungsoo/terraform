################################################################################
# Cost Explorer read access for other accounts (payer account = consolidated billing)
################################################################################
variable "cost_explorer_read_role_name" {
  type        = string
  description = "IAM role in the payer account that exposes organization-wide Cost Explorer data"
}

variable "cost_explorer_trusted_role_arns" {
  type        = list(string)
  description = "Role ARNs in member accounts allowed to assume the Cost Explorer read role (e.g. the dev cost exporter)"
}
