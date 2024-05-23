// basic_with_kms_mock.tftest.hcl
mock_provider "aws" {
  // der eigentliche Mock für unseren KMS Key
  mock_resource "aws_kms_key" {
    defaults = {
      arn = "arn:aws:kms:eu-central-1:123456789012:key/111199992-199219191"
    }
  }
}

run "create_kms_mock_key" {
  assert {
    condition     = aws_kms_key.test-key.arn != null
    error_message = "KMS key could not created"
  }
}

run "test_alias_creation" {
  variables {
    kms_key_alias = "alias/alias-name"
    kms_key_id    = "111199992-199219191"
  }

  assert {
    condition     = startswith(aws_kms_alias.alias-key.name, "alias/")
    error_message = "KMS key alias name did not start with the expected value of ‘alias/*’."
  }

  assert {
    condition     = aws_kms_alias.alias-key.target_key_id == "111199992-199219191"
    error_message = "KMS key target_id did not match with the expected value of ‘111199992-199219191’."
  }
}

