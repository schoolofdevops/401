# EC2 instance with CloudWatch monitoring and SNS alerts
# TODO: Use AI to generate the complete resource definitions
# Context: See CLAUDE.md in this directory before generating

# Data source: Latest Amazon Linux 2 AMI
# data "aws_ami" "amazon_linux" { ... }

# Resource: EC2 instance (t2.micro for free tier)
# resource "aws_instance" "this" { ... }

# Resource: CloudWatch CPU alarm
# resource "aws_cloudwatch_metric_alarm" "cpu_high" { ... }

# Resource: SNS topic for alerts
# resource "aws_sns_topic" "alerts" { ... }

# Resource: SNS email subscription
# resource "aws_sns_topic_subscription" "email" { ... }
