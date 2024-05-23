// kms.tf
resource "aws_kms_key" "test-key" {
  description             = "test KMS key"
  deletion_window_in_days = 7
}

output "kms_key_id" {
  value = aws_kms_key.test-key.arn
}



