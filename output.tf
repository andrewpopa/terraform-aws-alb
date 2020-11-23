output "alb_dns_name" {
  description = "aws DNS records for ALB"
  value       = aws_lb.app_lb.dns_name
}