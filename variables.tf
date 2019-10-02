# LB

variable "alb_tags" {
  type = map
  default = {
    lb = "alb-name"
  }
}

variable "name_cert" {
  type        = string
  default     = "alb-certs"
  description = "Certificates for load balancer"
}

variable "cert_body" {
  type        = string
  default     = ""
  description = "Certificate body"
}

variable "cert_chain" {
  type        = string
  default     = ""
  description = "Certificate chain"
}

variable "priv_key" {
  description = "Private key"
  type        = string
  default     = ""
}

variable "alb_name_prefix" {
  description = "Load balancer name prefix"
  type        = string
  default     = ""
}

variable "ssl_policy" {
  description = "Security policy"
  type        = string
  default     = "ELBSecurityPolicy-2016-08"
}

variable "ec2_instance" {
  description = "EC2 instance for load balancing"
  type        = string
}

variable "alb_target_group_name" {
  description = "ALB target group name"
  type        = string
  default     = ""
}

variable "tf_vpc" {
  description = "VPC ID"
  type        = string
  default     = ""
}

variable "tf_subnet" {
  description = "VPC list of subnets"
  type        = list
}

variable "sg_id" {
  description = "Security Group ID"
  type        = string
  default     = ""
}

variable "lbports" {
  description = "Default ALB listener port and protocol"
  default = {
    443  = "HTTPS",
  }
}