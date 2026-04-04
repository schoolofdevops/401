output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.this.id
}

output "instance_public_ip" {
  description = "The public IP address of the EC2 instance (empty if no public IP assigned)"
  value       = aws_instance.this.public_ip
}

output "alarm_arn" {
  description = "The ARN of the CloudWatch CPU utilization alarm"
  value       = aws_cloudwatch_metric_alarm.cpu_high.arn
}

output "sns_topic_arn" {
  description = "The ARN of the SNS topic used for alarm notifications"
  value       = aws_sns_topic.alerts.arn
}
