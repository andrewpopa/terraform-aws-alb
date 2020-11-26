output "alb_dns_name" {
  description = "aws DNS records for ALB"
  value       = aws_lb.app_lb.dns_name
}

output "target_group_arn" {
  value       = aws_lb_target_group.tf_target_frontend.*.arn
  description = "list of target group arns"
}