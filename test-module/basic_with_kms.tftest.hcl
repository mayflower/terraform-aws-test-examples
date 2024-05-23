// basic_with_kms.tftest.hcl
run "setup" {
  // wie sonst auch, führt 'terraform test' ein apply aus
  command = apply
  // erstellt uns den KMS Key im AWS
  module {
    source = "./setup"
  }
}

run "create_kms_key" {
  command = plan

  variables {
    kms_key_id = run.setup.kms_key_id
  }

  assert {
    condition     = aws_kms_alias.alias-key.target_key_id != null
    error_message = "KMS key ID attribute value is null"
  }
}

run "test_alias_creation" {
  command = plan

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

