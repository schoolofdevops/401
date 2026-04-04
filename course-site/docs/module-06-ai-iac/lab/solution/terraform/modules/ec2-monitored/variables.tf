variable "instance_name" {
  description = "Name tag for the EC2 instance — also used as prefix for alarm and SNS topic names"
  type        = string
}

variable "alarm_threshold" {
  description = "CPU utilization percentage threshold to trigger the CloudWatch alarm"
  type        = number
  default     = 80

  validation {
    condition     = var.alarm_threshold > 0 && var.alarm_threshold <= 100
    error_message = "alarm_threshold must be between 1 and 100 (percent)."
  }
}

variable "notification_email" {
  description = "Email address for CloudWatch alarm notifications via SNS. Subscriber must confirm the subscription email."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the EC2 instance. Defaults to the account's default VPC when not specified."
  type        = string
  default     = null
}
