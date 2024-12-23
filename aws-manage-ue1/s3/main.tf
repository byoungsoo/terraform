resource "aws_s3_bucket" "s3-terraform" {
  bucket = "${var.project_code}-${var.account}-${var.aws_region_code}-s3-terraform"

  tags = {
    auto-delete = "no"
  }
}