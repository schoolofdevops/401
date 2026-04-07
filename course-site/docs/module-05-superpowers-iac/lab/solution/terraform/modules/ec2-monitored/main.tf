# EC2 instance with CloudWatch monitoring and SNS alerts
# Complete solution — compare against your AI-generated code

# Data source: Latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Resource: EC2 instance (t2.micro — free tier eligible)
resource "aws_instance" "this" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  monitoring    = false # basic monitoring — detailed monitoring costs $0.01/metric/month

  tags = {
    Name        = var.instance_name
    Environment = "lab"
    ManagedBy   = "terraform"
  }
}

# Resource: CloudWatch CPU alarm
resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "${var.instance_name}-cpu-high"
  alarm_description   = "Alarm when CPU utilization exceeds ${var.alarm_threshold}% for 10 consecutive minutes"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300 # 5 minutes per period, 2 periods = 10 minute sustained threshold
  statistic           = "Average"
  threshold           = var.alarm_threshold
  treat_missing_data  = "notBreaching"

  dimensions = {
    InstanceId = aws_instance.this.id
  }

  alarm_actions = [aws_sns_topic.alerts.arn]

  tags = {
    Name      = "${var.instance_name}-cpu-high"
    ManagedBy = "terraform"
  }
}

# Resource: SNS topic for alarm notifications
resource "aws_sns_topic" "alerts" {
  name = "${var.instance_name}-alerts"

  tags = {
    Name      = "${var.instance_name}-alerts"
    ManagedBy = "terraform"
  }
}

# Resource: SNS email subscription (email protocol — free, unlike SMS)
resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.notification_email
}
