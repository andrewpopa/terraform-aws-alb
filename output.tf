output "alb_dns_name" {
  description = "aws DNS records for ALB"
  value       = aws_lb.tf_alb.dns_name
}