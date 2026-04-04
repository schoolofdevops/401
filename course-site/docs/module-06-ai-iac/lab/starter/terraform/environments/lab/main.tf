provider "aws" {
  region = "us-east-1"
}

module "app" {
  source = "../../modules/ec2-monitored"

  instance_name      = var.instance_name
  alarm_threshold    = var.alarm_threshold
  notification_email = var.notification_email
}

variable "instance_name" {
  default = "agentic-devops-lab"
}

variable "alarm_threshold" {
  default = 80
}

variable "notification_email" {
  description = "Email for CloudWatch alarm notifications"
  type        = string
}
