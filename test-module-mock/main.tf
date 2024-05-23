//main.tf
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

variable "kms_key_alias" {
  type    = string
  default = "alias/my-alias"

  validation {
    condition     = length(var.kms_key_alias) >= 9
    error_message = "The kms_key_alias name must be longer than 3 chars and contain 'alias/' prefix"
  }
}

variable "kms_key_id" {
  type    = string
  default = "null"
}

resource "aws_kms_alias" "alias-key" {
  name          = var.kms_key_alias != "" ? var.kms_key_alias : null
  target_key_id = var.kms_key_id != "" ? var.kms_key_id : null
}

resource "aws_kms_key" "test-key" {
  description             = "test KMS key for CodeCommit repo"
  deletion_window_in_days = 7
}

output "kms_key_id" {
  value = aws_kms_key.test-key.arn
}


