variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
}

# TODO: Add variable alarm_threshold (number, default 80) for CPU utilization threshold
# TODO: Add variable notification_email (string) for SNS email subscription endpoint
# TODO: Add variable vpc_id (string, optional) for future VPC placement support
