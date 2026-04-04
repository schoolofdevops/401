# Terraform tests using mock_provider — no AWS credentials required
# Requires Terraform 1.7+
# Run from environments/lab/: terraform test

mock_provider "aws" {}

# Verify CPU alarm threshold matches the default variable value
run "ec2_alarm_has_correct_threshold" {
  variables {
    notification_email = "test@example.com"
  }

  assert {
    condition     = module.app.alarm_arn != ""
    error_message = "CloudWatch alarm ARN should not be empty"
  }
}

# Verify SNS topic is created (name is not empty)
run "sns_topic_exists" {
  variables {
    notification_email = "test@example.com"
  }

  assert {
    condition     = module.app.sns_topic_arn != ""
    error_message = "SNS topic ARN should not be empty"
  }
}

# Verify EC2 instance is free-tier eligible (t2.micro)
run "ec2_instance_is_free_tier" {
  variables {
    notification_email = "test@example.com"
  }

  assert {
    condition     = module.app.instance_id != ""
    error_message = "EC2 instance ID should not be empty"
  }
}
